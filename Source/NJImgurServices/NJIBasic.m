//
//  NJIBasic.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIBasic.h"

#define NJI_NJIBASIC_PARAMETER_DATA             @"data"
#define NJI_NJIBASIC_PARAMETER_SUCCESS          @"success"
#define NJI_NJIBASIC_PARAMETER_HTTPSTATUSCODE   @"status"

@interface NJIBasic ()

@property (nonatomic, strong) id          data;
@property (nonatomic, assign) BOOL        success;
@property (nonatomic, assign) NSUInteger  HTTPStatusCode;

@end

@implementation NJIBasic

- (id)initWithJSONData:(NSData *)data
{
    self = [super initWithJSONData:data];
    
    if (self)
    {
        @try
        {
            self.data = [self.JSONDictionary objectForKey:NJI_NJIBASIC_PARAMETER_DATA];
            self.success = [[self.JSONDictionary objectForKey:NJI_NJIBASIC_PARAMETER_SUCCESS] boolValue];
            self.HTTPStatusCode = [[self.JSONDictionary objectForKey:NJI_NJIBASIC_PARAMETER_HTTPSTATUSCODE] integerValue];
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
