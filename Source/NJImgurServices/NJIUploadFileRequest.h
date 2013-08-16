//
//  NJIUploadFileRequest.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIMutableURLRequest.h"
#import "NJIUpload.h"

@interface NJIUploadFileRequest : NJIMutableURLRequest

- (id)initWithUpload:(NJIUpload*)upload;

@end
