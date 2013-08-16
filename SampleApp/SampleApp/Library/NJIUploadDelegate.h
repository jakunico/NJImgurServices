//
//  NJIUploadDelegate.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIUpload.h"
#import "NJIResponseStatus.h"
#import "NJIUploadImageResponse.h"

/**
 Use this delegate to be informed about your uploads
 */
@protocol NJIUploadDelegate <NSObject>

@required

/**
 This method is called when the upload operation of an image finishes successfully
 @param image This is the original upload object
 @param resultImage This is the result image containing all the metadata of the image uploaded
 @discussion This method is always called in the main thread
 */
- (void)finishedUploadingImage:(NJIUpload*)image withResult:(NJIUploadImageResponse*)uploadResponse;

/**
 This method is called when the upload operation of an image fails
 @param image The original upload object
 @param error The error why the upload failed
 @discussion This method is always called in the main thread
 */
- (void)failedToUploadImage:(NJIUpload*)image withError:(NJIResponseStatus)error;

@optional

/**
 If during a connection attempt the request remains idle for longer than the timeout interval, the request is considered to have timed out.
 @param image The image for which you'll set the timeout
 @return The timeout interval in seconds
 @discussion If you decide to not implement this method, the timeout period will be set to whatever Apple sets by default to NSURLRequest objects (4 minutes @ Jun 2013)
 @discussion This method is called on a per-upload basis, meaning that you can set the timeout period to be different depending on the image being uploaded
 @discussion This method is NOT called in the main thread because we don't expect you to do any UI update here.
 */
- (NSTimeInterval)timeoutIntervalForUpload:(NJIUpload*)image;

@end
