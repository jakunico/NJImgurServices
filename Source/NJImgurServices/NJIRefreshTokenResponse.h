//
//  NJIRefreshTokenResponse.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/25/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIBaseResponse.h"

/**
 @see https://api.imgur.com/oauth2#refresh_tokens
 */
@interface NJIRefreshTokenResponse : NJIBaseResponse

@property (nonatomic, readonly) NSString*       accessToken;
@property (nonatomic, readonly) NSString*       refreshToken;
@property (nonatomic, readonly) NSString*       tokenType;
@property (nonatomic, readonly) NSString*       accountUsername;
@property (nonatomic, readonly) NSDate*         expirationDate;

@end
