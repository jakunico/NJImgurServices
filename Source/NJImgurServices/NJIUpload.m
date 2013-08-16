//
//  NJIUpload.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUpload.h"
#import "NJIRequestParameter.h"
#import "NSData+Base64.h"

#define NJI_NJIUPLOAD_PARAMETER_IMAGE           @"image"
#define NJI_NJIUPLOAD_PARAMETER_ALBUM           @"album"
#define NJI_NJIUPLOAD_PARAMETER_FILENAME        @"name"
#define NJI_NJIUPLOAD_PARAMETER_TITLE           @"title"
#define NJI_NJIUPLOAD_PARAMETER_DESCRIPTION     @"description"

@interface NJIUpload ()

@property (nonatomic, strong) UIImage*  image;

@end

@implementation NJIUpload

- (id)initWithImage:(UIImage*)image
{
    if ([image isKindOfClass:[UIImage class]] == NO)
    {
        NSLog(@"NJIUpload > A valid UIImage is required");
        return nil;
    }

    self = [super init];
    
    if (self)
    {
        self.image = image;
    }
    
    return self;
}

#pragma mark - NJIRequestParameterProtocol Methods -

- (NSArray*)parametersForRequest
{
    NSMutableArray* parameterArray = [[NSMutableArray alloc] init];
    
    if (self.image)
    {
        NSData* imageData = UIImagePNGRepresentation(self.image);
        
        NSString* base64ImageString = [imageData base64EncodedString];
        
        NJIRequestParameter* parameter = [[NJIRequestParameter alloc] initWithKey:NJI_NJIUPLOAD_PARAMETER_IMAGE
                                                                            value:base64ImageString];
        
        if (parameter)
        {
            [parameterArray addObject:parameter];
        }
    }
    
    if (self.album)
    {
        NJIRequestParameter* parameter = [[NJIRequestParameter alloc] initWithKey:NJI_NJIUPLOAD_PARAMETER_ALBUM
                                                                            value:self.album];
        
        if (parameter)
        {
            [parameterArray addObject:parameter];
        }
    }
    
    if (self.fileName)
    {
        NJIRequestParameter* parameter = [[NJIRequestParameter alloc] initWithKey:NJI_NJIUPLOAD_PARAMETER_FILENAME
                                                                            value:self.fileName];
        
        if (parameter)
        {
            [parameterArray addObject:parameter];
        }
    }
    
    if (self.title)
    {
        NJIRequestParameter* parameter = [[NJIRequestParameter alloc] initWithKey:NJI_NJIUPLOAD_PARAMETER_TITLE
                                                                            value:self.title];
        
        if (parameter)
        {
            [parameterArray addObject:parameter];
        }
    }
    
    if (self.description)
    {
        NJIRequestParameter* parameter = [[NJIRequestParameter alloc] initWithKey:NJI_NJIUPLOAD_PARAMETER_DESCRIPTION
                                                                            value:self.description];
        
        if (parameter)
        {
            [parameterArray addObject:parameter];
        }
    }
    
    return parameterArray;
    
}

@end
