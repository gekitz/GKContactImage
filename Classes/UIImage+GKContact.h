//
// Created by Georg Kitz on 01/05/14.
// Copyright (c) 2014 Tracr Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (GKContact)

/**
* @brief Creates an image with initials using the given name. Default values will be used for colors and fonts.
*
* @param name The name to extract initials from.
* @param size The size of the image to be created.
*
* @return An image with initials extracted from the given name.
*/
+ (instancetype)imageForName:(NSString *)name size:(CGSize)size;

/**
* @brief Creates an image with initials using the given name.
*
* @param name The name to extract initials from.
* @param size The size of the image to be created.
* @param backgroundColor The background color of the initials image.
* @param textColor The color to fill the initials with.
* @param font The font to draw the initials with.
*
* @return An image with initials extracted from the given name.
*/
+ (instancetype)imageForName:(NSString *)name size:(CGSize)size backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor font:(UIFont *)font;

@end