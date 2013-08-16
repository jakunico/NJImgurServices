//
//  NJIAPIEndpoints.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIAPIEndpoints.h"
#import "NJIConstants.h"
#import "NJIRequestParameter.h"

@interface NJIAPIEndpoints ()

+ (NSString*)uploadEndpoint;
+ (NSString*)baseEndpointURL;

@end

@implementation NJIAPIEndpoints

#pragma mark Private Methods
#pragma mark -

+ (NSString*)baseEndpointURL
{
    return [NJI_API_BASE_URL stringByAppendingPathComponent:NJI_API_VERSION];
}

+ (NSString*)uploadEndpoint
{
    return [[NJIAPIEndpoints baseEndpointURL] stringByAppendingPathComponent:NJI_API_UPLOAD_RESOURCE];
}

+ (NSString*)creditsEndpoint
{
    return [[NJIAPIEndpoints baseEndpointURL] stringByAppendingPathComponent:NJI_API_CREDITS_RESOURCE];
}

#pragma mark Public Methods
#pragma mark -

+ (NSURL*)uploadURL
{
    NSString* uploadEndpoint = [NJIAPIEndpoints uploadEndpoint];
    return [NSURL URLWithString:uploadEndpoint];
}

+ (NSURL*)authorizationURLWithClientId:(NSString*)clientId responseType:(NSString*)responseType
{
    NJIRequestParameter *clientIdParameter = [[NJIRequestParameter alloc] initWithKey:@"client_id" value:clientId];
    NJIRequestParameter *responseTypeParameter = [[NJIRequestParameter alloc] initWithKey:@"response_type" value:responseType];
    
    NSString* parameters = [NJIRequestParameter stringRepresentationForParameters:@[clientIdParameter, responseTypeParameter]];
    
    if (!parameters)
    {
        return nil;
    }
    
    NSString* endpointURL = [NJI_API_BASE_URL stringByAppendingPathComponent:NJI_API_AUTHORIZE_RESOURCE];
    
    endpointURL = [endpointURL stringByAppendingString:@"?"];
    
    endpointURL = [endpointURL stringByAppendingString:parameters];
    
    return [NSURL URLWithString:endpointURL];
}

+ (NSURL*)refreshTokenURL
{
    NSString* urlString = [NJI_API_BASE_URL stringByAppendingPathComponent:NJI_API_REFRESH_TOKEN_RESOURCE];
    
    return [NSURL URLWithString:urlString];
}

+ (NSURL*)creditsURL
{
    return [NSURL URLWithString:[NJIAPIEndpoints creditsEndpoint]];
}

@end
