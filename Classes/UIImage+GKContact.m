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

        NSUInteger end = [part rangeOfComposedCharacterSequenceAtIndex:0].length;
        [initials appendString:[part substringToIndex:end]];

        if (idx == 1) {
            *stop = YES;
        };
    }];

    return initials;
}

static inline NSString *GKContactKey(NSString *initials, CGSize size, UIColor *backgroundColor, UIColor *textColor, UIFont *font) {
    return [NSString stringWithFormat:@"%@-%f-%f-%@-%@-%@", initials, size.width, size.height, backgroundColor.description, textColor.description, font.description];
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
    return self.cachedImages[key];
}

+ (void)setImage:(UIImage *)image forKey:(NSString *)key {
    self.cachedImages[key] = image;
}

#pragma mark -
#pragma mark Image Drawing

+ (UIImage *)drawImageForInitials:(NSString *)initials size:(CGSize)imageSize backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [self drawImageForInitials:initials size:imageSize backgroundColor:backgroundColor backgroundGradientColor:nil textColor:textColor font:font];
}

+ (UIImage *)drawImageForInitials:(NSString *)initials size:(CGSize)imageSize backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(UIColor *)backgroundGradientColor textColor:(UIColor *)textColor font:(UIFont *)font
{
    CGFloat w = imageSize.width;
    CGFloat h = imageSize.height;
    CGFloat r = imageSize.width / 2;

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, backgroundColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);

    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, w, h)];
    [path addClip];
    [path setLineWidth:1.0f];
    [path stroke];
    
    if (backgroundGradientColor) {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat colorComponents[8]; // RGBA x 2
        [backgroundColor getRed:&colorComponents[0] green:&colorComponents[1] blue:&colorComponents[2] alpha:&colorComponents[3]];
        [backgroundGradientColor getRed:&colorComponents[4] green:&colorComponents[5] blue:&colorComponents[6] alpha:&colorComponents[7]];
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, NULL, 2);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0, h), CGPointMake(w, 0), 0);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    } else {
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, w, h));
    }
    
    NSDictionary *dict = @{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor};
    CGSize textSize = [initials sizeWithAttributes:dict];

    BOOL isRTLLanguage;
    if ([[[[NSBundle mainBundle] bundlePath] pathExtension] isEqualToString:@"appex"]) {
        // App Extensions may not access -[UIApplication sharedApplication]; fall back to checking the bundle's preferred localization character direction
        isRTLLanguage = [NSLocale characterDirectionForLanguage:[[NSBundle mainBundle] preferredLocalizations][0]] == NSLocaleLanguageDirectionRightToLeft;
    } else {
        // Use dynamic call to sharedApplication to workaround compilation error when building against app extensions
        isRTLLanguage = [[UIApplication performSelector:@selector(sharedApplication)] userInterfaceLayoutDirection] == UIUserInterfaceLayoutDirectionRightToLeft;
    }
    
    NSInteger xFactor = isRTLLanguage ? -1 : 1;
    [initials drawInRect:CGRectMake(xFactor * (r - textSize.width / 2), r - font.lineHeight / 2, textSize.width, textSize.height) withAttributes:dict];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)imageForName:(NSString *)name size:(CGSize)size {

    // Default colors.
    UIColor *defaultBackgroundColor = [UIColor colorWithRed:0.784 green:0.776 blue:0.800 alpha:1];
    UIColor *defaultTextColor = [UIColor whiteColor];

    // Default font.
    CGFloat r = size.width / 2;
    UIFont *font = [UIFont systemFontOfSize:r - 1];

    return [self imageForName:name  size:size backgroundColor:defaultBackgroundColor textColor:defaultTextColor font:font];
}

+ (instancetype)imageForName:(NSString *)name size:(CGSize)size backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [self imageForName:name size:size backgroundColor:backgroundColor backgroundGradientColor:nil textColor:textColor font:font];
}

+ (instancetype)imageForName:(NSString *)name size:(CGSize)size backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(UIColor *)backgroundGradientColor textColor:(UIColor *)textColor font:(UIFont *)font
{
    NSString *initials = GKInitials(name);
    NSString *key = GKContactKey(initials, size, backgroundColor, textColor, font);

    UIImage *image = [self imageForKey:key];
    if (!image) {
        image = [self drawImageForInitials:initials size:size backgroundColor:backgroundColor backgroundGradientColor:backgroundGradientColor textColor:textColor font:font];
        [self setImage:image forKey:key];
    }

    return image;
}


@end
