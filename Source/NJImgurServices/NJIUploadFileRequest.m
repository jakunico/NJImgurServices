//
//  NJIUploadFileRequest.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadFileRequest.h"
#import "NJIAPIEndpoints.h"
#import "NJIConstants.h"

@implementation NJIUploadFileRequest

- (id)initWithUpload:(NJIUpload*)upload
{
    if (!upload)
    {
        return nil;
    }
    
    NSURL* uploadURL = [NJIAPIEndpoints uploadURL];

    self = [super initWithURL:uploadURL];

    if (self)
    {
        self.HTTPMethod = NJI_HTTP_METHOD_POST;
        
        NSArray* parameters = [upload parametersForRequest];
        
        [self setHTTPBodyParameters:parameters];
    }

    return self;
}

@end
