//
// Created by Georg Kitz on 01/05/14.
// Copyright (c) 2014 Tracr Ltd. All rights reserved.
//

#import "UIImage+GKContact.h"

static inline NSString *GKInitials(NSString *name) {
    __block NSMutableString *initials = [NSMutableString new];
    NSArray *array = [name componentsSeparatedByString:@" "];
    [array enumerateObjectsUsingBlock:^(NSString *part, NSUInteger idx, BOOL *stop) {

        if (part.length == 0) {
            return;
        }

        [initials appendString:[part substringToIndex:1]];

        if (idx == 1) {
            *stop = YES;
        };
    }];

    return initials;
}

static inline NSString *GKContactKey(NSString *initials, CGSize size) {
    return [NSString stringWithFormat:@"%@-%f-%f", initials, size.width, size.height];
}

@implementation UIImage (GKContact)


#pragma mark -
#pragma mark Cache

+ (NSMutableDictionary *)cachedImages {
    static NSMutableDictionary *items = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
       items = [NSMutableDictionary new];
    });

    return items;
}

+ (UIImage *)imageForKey:(NSString *)key {
    return [self.cachedImages objectForKey:key];
}

+ (void)setImage:(UIImage *)image forKey:(NSString *)key {
    return [self.cachedImages setObject:image forKey:key];
}

#pragma mark -
#pragma mark Image Drawing

+ (UIImage *)drawImageForInitials:(NSString *)initials size:(CGSize)imageSize {

    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;
    CGFloat r = imageSize.width / 2;

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, w, h)];
    [path addClip];
    [path setLineWidth:1.0f];
    [path stroke];

    UIColor *color = [UIColor colorWithRed:0.784 green:0.776 blue:0.800 alpha:1];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, w, h));

    UIFont *font = [UIFont systemFontOfSize:r - 1];
    NSDictionary *dict = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor whiteColor]};
    CGSize textSize = [initials sizeWithAttributes:dict];

    [initials drawInRect:CGRectMake(r - textSize.width / 2, r - font.lineHeight / 2, w, h) withAttributes:dict];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)imageForName:(NSString *)name size:(CGSize)size {

    NSString *initials = GKInitials(name);
    NSString *key = GKContactKey(initials, size);

    UIImage *image = [self imageForKey:key];
    if (!image) {
        image = [self drawImageForInitials:initials size:size];
        [self setImage:image forKey:key];
    }

    return image;
}


@end