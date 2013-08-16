//
//  NJIURLConnection.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIURLConnection.h"
#import "NSHTTPURLResponse+NJIAdditions.h"
#import "NJIRefreshTokenRequest.h"
#import "NJIRefreshTokenResponse.h"
#import "NJIJSONController.h"
#import "NJIAuthenticationController.h"

@interface NJIURLConnection ()

/**
 Use this method to send a synchronous request to the server
 @param request The request to perform
 @param data Output parameter where response data will be added
 @param response Output parameter where response will be added
 @param shouldRefreshToken If YES, we'll attempt to refresh token and repeat the same request in case token expires. If NO, we'll not attempt to refresh token and request would just fail.
 @return The status of the request
 @discussion If the request fails, you should check the NJIResponseStatus enum to know the failure reason
 @discussion If the request fails, data will be nil
 */
+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest *)request
                              returningData:(NSData *__autoreleasing *)data
                          returningResponse:(NSHTTPURLResponse *__autoreleasing *)response
                         shouldRefreshToken:(BOOL)shouldRefreshToken;

/**
 Use this method to refresh the access token synchronously
 */
+ (NJIResponseStatus)refreshTokenSynchronously;

@end

@implementation NJIURLConnection

+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest*)request returningData:(NSData *__autoreleasing *)data
{
    return [NJIURLConnection sendSynchronousRequest:request returningData:data returningResponse:nil];
}

+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest*)request
                              returningData:(NSData *__autoreleasing *)data
                          returningResponse:(NSHTTPURLResponse *__autoreleasing *)response
{
    return [NJIURLConnection sendSynchronousRequest:request returningData:data returningResponse:response shouldRefreshToken:YES];
}

+ (NJIResponseStatus)sendSynchronousRequest:(NSURLRequest *)request
                              returningData:(NSData *__autoreleasing *)data
                          returningResponse:(NSHTTPURLResponse *__autoreleasing *)response
                         shouldRefreshToken:(BOOL)shouldRefreshToken
{
    NSError* error = nil;
    
    DLog(@"Performing request to endpoint %@", [request.URL absoluteString]);
    
    *data = [NSURLConnection sendSynchronousRequest:request returningResponse:response error:&error];
    
    DLog(@"Request finished with response %@", *response);
    DLog(@"Request finished with error %@", error);
    
    NJIResponseStatus responseStatus = NJIResponseStatusFailedWithUnknownReason;
    
    if (response != nil)
    {
        DLog(@"Response string:\n%@\n", [[NSString alloc] initWithData:*data encoding:NSUTF8StringEncoding]);
        responseStatus = [*response responseStatus];
        
        if (responseStatus == NJIResponseStatusForbidden && shouldRefreshToken)
        {
            DLog(@"Token expired... will try to refresh it!");
            NJIResponseStatus refreshTokenStatus = [NJIURLConnection refreshTokenSynchronously];
            
            if (refreshTokenStatus == NJIResponseStatusEverythingOkay)
            {
                DLog(@"Token has been updated correctly, I'll attempt to do the original request again");
                //Token refreshed correctly
                //This time, don't try to refresh if it expires somehow, this will avoid an endless loop
                responseStatus = [NJIURLConnection sendSynchronousRequest:request returningData:data returningResponse:response shouldRefreshToken:NO];
            }
            else
            {
                //Could not refresh token, logout the user
                [[NJIAuthenticationController instance] logout];
            }
        }
    }
    else if (error != NULL)
    {
        if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNetworkConnectionLost || error.code == NSURLErrorNotConnectedToInternet)
        {
            DLog(@"Request failed because you're not connected to internet.");
            responseStatus = NJIResponseStatusMissingInternetConnection;
        }
        else if (error.code == NSURLErrorTimedOut)
        {
            DLog(@"Request failed because it timed out");
            responseStatus = NJIResponseStatusRequestTimedOut;
        }
        else
        {
            DLog(@"Request failed because of an unknown reason");
            responseStatus = NJIResponseStatusFailedWithUnknownReason;
        }
    }
    
    return responseStatus;
   
}

+ (NJIResponseStatus)refreshTokenSynchronously
{
    NJIRefreshTokenRequest *refreshTokenRequest = [[NJIRefreshTokenRequest alloc] init];
    
    if (!refreshTokenRequest)
    {
        return NJIResponseStatusFailedWithUnknownReason;
    }

    NSData* data = nil;

    NJIResponseStatus refreshTokenStatus = [NJIURLConnection sendSynchronousRequest:refreshTokenRequest returningData:&data returningResponse:nil shouldRefreshToken:NO];

    if (refreshTokenStatus == NJIResponseStatusEverythingOkay)
    {
        NSDictionary* dictionary = [NJIJSONController dictionaryFromJSONData:data];
        
        NJIRefreshTokenResponse *refreshTokenResponse = [[NJIRefreshTokenResponse alloc] initWithDictionary:dictionary responseHTTPHeaders:nil];
        
        if (refreshTokenResponse)
        {
            //Update the tokens
            BOOL success = [[NJIAuthenticationController instance] updateCredentialsTo:refreshTokenResponse];
            
            if (!success)
            {
                //Something went wrong when updating the credentials, user may have unauthorized the application
                refreshTokenStatus = NJIResponseStatusFailedWithUnknownReason;
                
                //Logout user to obtain new credentials
                [[NJIAuthenticationController instance] logout];
            }
        }
        else
        {
            DLog(@"Failed to update token because we were unable to parse JSON response to the refresh token request");
            refreshTokenStatus = NJIResponseStatusUnableToParseJSON;
        }
    }
    
    return refreshTokenStatus;

}

@end
