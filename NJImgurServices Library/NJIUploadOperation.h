//
//  NJIUploadOperation.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIUpload.h"
#import "NJIUploadDelegate.h"

@interface NJIUploadOperation : NSOperation

/**
 Use this method to create an upload operation
 @param upload The upload object containing the image to upload
 @param delegate The delegate of the upload
 @return a newly initialized NJIUploadOperation object or nil if something goes wrong
 */
- (id)initWithUpload:(NJIUpload*)upload withDelegate:(id<NJIUploadDelegate>)delegate;

@end
