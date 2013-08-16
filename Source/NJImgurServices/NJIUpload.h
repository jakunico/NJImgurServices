//
//  NJIUpload.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NJIRequestParameterProtocol.h"

/**
 Use this object to upload an image
 @see http://api.imgur.com/endpoints/image#image-upload
 */
@interface NJIUpload : NSObject<NJIRequestParameterProtocol>

/**
 The image that is going to be uploaded
 @discussion This property is readonly, you must use initWithImage: to set this guy
 */
@property (nonatomic, readonly) UIImage*    image;

/**
 The id of the album you want to add the image to. For anonymous albums, {album} should be the deletehash that is returned at creation (Optional).
 */
@property (nonatomic, strong)   NSString*   album;

/**
 The name of the file (Optional).
 */
@property (nonatomic, strong)   NSString*   fileName;

/**
 The title of the image (Optional).
 */
@property (nonatomic, strong)   NSString*   title;

/**
 The description of the image (Optional).
 */
@property (nonatomic, strong)   NSString*   description;

/**
 Use this method to initialize an object
 @param image The image to upload
 */
- (id)initWithImage:(UIImage*)image;

@end
