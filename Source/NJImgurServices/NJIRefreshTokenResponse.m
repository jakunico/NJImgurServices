//
//  NJIRefreshTokenResponse.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/25/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIRefreshTokenResponse.h"
#import "NJIDateUtils.h"

#define NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_ACCESS_TOKEN      @"access_token"
#define NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_REFRESH_TOKEN     @"refresh_token"
#define NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_TOKEN_TYPE        @"token_type"
#define NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_ACCOUNT_USERNAME  @"account_username"
#define NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_EXPIRES_IN        @"expires_in"

@interface NJIRefreshTokenResponse ()

@property (nonatomic, strong) NSString*       accessToken;
@property (nonatomic, strong) NSString*       refreshToken;
@property (nonatomic, strong) NSString*       tokenType;
@property (nonatomic, strong) NSString*       accountUsername;
@property (nonatomic, strong) NSDate*         expirationDate;

@end

@implementation NJIRefreshTokenResponse

- (id)initWithDictionary:(NSDictionary *)dictionary responseHTTPHeaders:(NSDictionary *)headers
{
    self = [super initWithDictionary:dictionary responseHTTPHeaders:headers];
    
    if (self)
    {
        @try
        {
            self.accessToken = [dictionary objectForKey:NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_ACCESS_TOKEN];
            self.refreshToken = [dictionary objectForKey:NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_REFRESH_TOKEN];
            self.tokenType = [dictionary objectForKey:NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_TOKEN_TYPE];
            self.accountUsername = [dictionary objectForKey:NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_ACCOUNT_USERNAME];
            self.expirationDate = [NJIDateUtils addSeconds:[[dictionary objectForKey:NJI_NJIREFRESHTOKENRESPONSE_PARAMETER_EXPIRES_IN] intValue]
                                                    toDate:[NSDate date]];
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
