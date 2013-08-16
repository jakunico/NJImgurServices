//
//  NJIURLConnection.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIResponseStatus.h"

@interface NJIURLConnection : NSURLConnection

/**
 Use this method to send a synchronous request to the server
 @param request The request to perform
 @param data Output parameter where response data will be added
 @param response Output parameter where response will be added
 @return The status of the request
 @discussion If the request fails, you should check the NJIResponseStatus enum to know the failure reason
 @discussion If the request fails, data will be nil
 */
+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest*)request returningData:(NSData *__autoreleasing *)data;

+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest*)request returningData:(NSData *__autoreleasing *)data returningResponse:(NSHTTPURLResponse *__autoreleasing *)response;

@end
