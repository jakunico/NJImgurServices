//
//  NJIUploadImageResponse.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadImageResponse.h"

#define NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_IMAGEID        @"id"
#define NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_DELETEHASH     @"deletehash"
#define NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_LINK           @"link"

@interface NJIUploadImageResponse ()

@property (nonatomic, strong) NSString*         imageId;
@property (nonatomic, strong) NSString*         deleteHash;
@property (nonatomic, strong) NSString*         link;

@end

@implementation NJIUploadImageResponse

- (id)initWithDictionary:(NSDictionary *)dictionary responseHTTPHeaders:(NSDictionary *)headers
{
    self = [super initWithDictionary:dictionary responseHTTPHeaders:headers];
    
    if (self)
    {
        @try
        {
            self.imageId = [dictionary objectForKey:NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_IMAGEID];
            self.deleteHash = [dictionary objectForKey:NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_DELETEHASH];
            self.link = [dictionary objectForKey:NJI_NJIUPLOADIMAGERESPONSE_PARAMETER_LINK];
        }
        @catch (NSException *exception)
        {
            DLog(@"Exception occurred: %@", exception);
            self = nil;
        }
    }
    
    return self;
}



@end
