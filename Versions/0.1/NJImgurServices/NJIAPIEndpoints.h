//
//  NJIAPIEndpoints.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIAPIEndpoints : NSObject

/**
 Use this method to obtain the Upload Endpoint URL
 @see http://api.imgur.com/endpoints/image#image-upload
 */
+ (NSURL*)uploadURL;

/**
 Use this method to obtain the Authroization Endpoint URL
 @see https://api.imgur.com/oauth2#authorization
 */
+ (NSURL*)authorizationURLWithClientId:(NSString*)clientId responseType:(NSString*)responseType;

/**
 Use this method to obtain the refresh token Endpoint URL
 @see https://api.imgur.com/oauth2#refresh_tokens
 */
+ (NSURL*)refreshTokenURL;

/**
 Use this method to obtain the credits Endpoint URL
 @see http://api.imgur.com/#limits
 */
+ (NSURL*)creditsURL;

@end
