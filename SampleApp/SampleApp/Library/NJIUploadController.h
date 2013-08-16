//
//  NJIUploadController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIUpload.h"
#import "NJIUploadDelegate.h"

@interface NJIUploadController : NSObject

/**
 Use this method to obtain an instance of the upload controller
 */
+ (NJIUploadController*)instance;

/**
 Use this method to add a new upload to the upload queue
 @param upload The upload object to add to the queue
 @param delegate The delegate of the upload
 @discussion if an invalid upload object is provided, we won't add it to the queue
 @return YES if upload was correctly created and added to the upload queue, NO otherwise
 */
- (BOOL)addUpload:(NJIUpload*)upload withDelegate:(id<NJIUploadDelegate>)delegate;

/**
 Use this method to add multiple uploads to the upload queue
 @param uploadArray An array containing one or more NJIUpload objects
 @param delegate The delegate of the upload
 @return YES if all uploads were correctly added to the upload queue, NO if at least one failed
 */
- (BOOL)addUploads:(NSArray*)uploadArray withDelegate:(id<NJIUploadDelegate>)delegate;

/**
 Use this method to cancel all uploads in the queue
 */
- (void)cancelAllUploads;


/**
 Use this method to begin the background task to finish uploading images
 */
- (void)beginBackgroundTask;

@end
