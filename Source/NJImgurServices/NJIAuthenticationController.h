//
//  NJIAuthenticationController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJILoggedUser.h"
#import "NJIAuthenticationController.h"
#import "NJIRefreshTokenResponse.h"

@interface NJIAuthenticationController : NSObject

@property (nonatomic, readonly, copy) NJILoggedUser*  loggedUser;

/**
 Use this method to obtain an instance of the controller
 @discussion never attemp to alloc/init a controller
 */
+ (NJIAuthenticationController*)instance;

/**
 Use this method to capture access token, expiration date, tokey type, refresh token and username from the callback URL
 @param urlString The callbackURL including the parameters
 @return YES if data was captured correctly, NO if there was an error
 @discussion If this method returns NO, it usually means that the user has denied permission to your app
 */
- (BOOL)authenticateWithURLString:(NSString*)urlString;

/**
 Use this method to logout the user
 */
- (void)logout;

/**
 Use this method to update the credentials (access token, refresh token, etc) usually from a refresh token object generated by refreshing the token
 @param newCredentials The NJIRefreshTokenResponse object containing the new credentials
 @return YES if credentials were updated correctly, NO if something went wrong.
 */
- (BOOL)updateCredentialsTo:(NJIRefreshTokenResponse*)newCredentials;

@end
