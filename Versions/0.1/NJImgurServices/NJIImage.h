//
//  NJIUploadResult.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NJIApiModelObject.h"

/**
 @see http://api.imgur.com/models/image
 */
@interface NJIImage : NJIApiModelObject

/**
 The ID for the image
 */
@property (nonatomic, readonly) NSString*   imageId;

/**
 The title of the image.
 */
@property (nonatomic, readonly) NSString*   title;

/**
 Description of the image.
 */
@property (nonatomic, readonly) NSString*   description;

/**
 Time inserted into the gallery
 */
@property (nonatomic, readonly) NSDate*     datetime;

/**
 Image MIME type.
 */
@property (nonatomic, readonly) NSString*   type;

/**
 is the image animated
 */
@property (nonatomic, readonly) BOOL        animated;

/**
 The width of the image in pixels
 */
@property (nonatomic, readonly) NSUInteger  width;

/**
 The height of the image in pixels
 */
@property (nonatomic, readonly) NSUInteger  height;

/**
 The size of the image in bytes
 */
@property (nonatomic, readonly) NSUInteger  size;

/**
 The number of image views
 */
@property (nonatomic, readonly) NSUInteger  views;

/**
 Bandwidth consumed by the image in bytes
 */
@property (nonatomic, readonly) NSUInteger  bandwidth;

/**
 OPTIONAL, the deletehash, if you're logged in as the image owner
 */
@property (nonatomic, readonly) NSString*   deleteHash;

/**
 The direct link to the the image
 */
@property (nonatomic, readonly) NSString*   link;

/**
 The image object
 */
@property (nonatomic, readonly) UIImage*    image;

@end
