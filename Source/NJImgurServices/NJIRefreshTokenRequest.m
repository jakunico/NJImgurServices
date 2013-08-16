//
//  NJIReloadTokenRequest.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/25/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIRefreshTokenRequest.h"
#import "NJIAPIEndpoints.h"
#import "NJIConstants.h"
#import "NJIRequestParameter.h"
#import "NJILoggedUser.h"
#import "NJIAuthenticationController.h"
#import "NJIController.h"

#define NJI_NJIREFRESHTOKENREQUEST_PARAMETER_REFRESH_TOKEN      @"refresh_token"
#define NJI_NJIREFRESHTOKENREQUEST_PARAMETER_CLIENT_ID          @"client_id"
#define NJI_NJIREFRESHTOKENREQUEST_PARAMETER_CLIENT_SECRET      @"client_secret"
#define NJI_NJIREFRESHTOKENREQUEST_PARAMETER_GRANT_TYPE         @"grant_type"
#define NJI_NJIREFRESHTOKENREQUEST_PARAMETER_GRANT_TYPE_VALUE   @"refresh_token"

@implementation NJIRefreshTokenRequest

- (id)init
{
    NSURL *refreshTokenURL = [NJIAPIEndpoints refreshTokenURL];
    
    self = [super initWithURL:refreshTokenURL];
    
    if (self)
    {
        self.HTTPMethod = NJI_HTTP_METHOD_POST;
        
        NJILoggedUser *loggedUser = [[NJIAuthenticationController instance] loggedUser];
        
        NJIRequestParameter* refresh_token = [[NJIRequestParameter alloc] initWithKey:NJI_NJIREFRESHTOKENREQUEST_PARAMETER_REFRESH_TOKEN
                                                                                value:loggedUser.refreshToken];
        
        NJIRequestParameter* clientId = [[NJIRequestParameter alloc] initWithKey:NJI_NJIREFRESHTOKENREQUEST_PARAMETER_CLIENT_ID
                                                                           value:[[NJIController instance] clientId]];
        
        NJIRequestParameter* clientSecret = [[NJIRequestParameter alloc] initWithKey:NJI_NJIREFRESHTOKENREQUEST_PARAMETER_CLIENT_SECRET
                                                                               value:[[NJIController instance] clientSecret]];
        
        NJIRequestParameter* grantType = [[NJIRequestParameter alloc] initWithKey:NJI_NJIREFRESHTOKENREQUEST_PARAMETER_GRANT_TYPE
                                                                            value:NJI_NJIREFRESHTOKENREQUEST_PARAMETER_GRANT_TYPE_VALUE];
        
        [self setHTTPBodyParameters:@[refresh_token, clientId, clientSecret, grantType]];
    }
    
    return self;
}

@end
