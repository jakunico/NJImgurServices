//
//  NJIMutableURLRequest.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIMutableURLRequest.h"
#import "NJIRequestParameter.h"
#import "NJIController.h"
#import "NJIAuthenticationController.h"
#import "NJINotifications.h"

#define NJI_HEADER_AUTHORIZATION       @"Authorization"

@interface NJIMutableURLRequest ()

/**
 Adds the Authorization header needed to use the Imgur API anonymously
 @see https://api.imgur.com/oauth2#register
 @return YES if header was added correctly
 */
- (BOOL)addClientIdHeader;

@end

@implementation NJIMutableURLRequest

- (id)initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    
    if (self)
    {
        if (![self loadAuthenticationHeader])
        {
            self = nil;
        }
        else
        {
            //Listen to access token changes so we can update this request's authorization headers
            [[NSNotificationCenter defaultCenter] addObserverForName:NJI_NOTIFICATION_ACCESS_TOKEN_UPDATED
                                                              object:nil
                                                               queue:nil
                                                          usingBlock:^(NSNotification *note) {
                                                              DLog(@"Will update authentication headers in %@", self);
                                                              [self loadAuthenticationHeader];
                                                          }];
        }
        
    }
    
    return self;
}

- (void)setHTTPBodyParameters:(NSArray*)parameters
{
    NSString *requestBody = [NJIRequestParameter stringRepresentationForParameters:parameters];
        
    self.HTTPBody = [requestBody dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)loadAuthenticationHeader
{
    BOOL success = YES;

    if ([[NJIController instance] loggedUser] == nil)
    {
        //There is no logged user, we should only load the authentication header with the clientId
        if ([self addClientIdHeader] == NO)
        {
            DLog(@"Unable to load anonymous authorization header (did you set the clientId?)");
            success = NO;
        }
        else
        {
            DLog(@"Loaded anonymous authorization header");
        }
    }
    else
    {
        if ([self addUserAuthenticationHeader] == NO)
        {
            DLog(@"Unable to load user authorization header (extremely strange case)");
            success = NO;
        }
        else
        {
            DLog(@"Loaded access token authroization header");
        }
    }

    return success;
}

- (BOOL)addClientIdHeader
{
    NSString* clientId = [[NJIController instance] clientId];
    
    BOOL success = NO;
    
    if (clientId)
    {
        NSString* headerValue = [NSString stringWithFormat:@"Client-ID %@", clientId];
        DLog(@"Loading header: %@ %@", NJI_HEADER_AUTHORIZATION, headerValue);
        [self setValue:headerValue forHTTPHeaderField:NJI_HEADER_AUTHORIZATION];
        success = YES;
    }
    
    return success;
}

- (BOOL)addUserAuthenticationHeader
{
    NSString* tokenType = [[[NJIAuthenticationController instance] loggedUser] tokenType];
    NSString* accessToken = [[[NJIAuthenticationController instance] loggedUser] accessToken];
    
    BOOL success = NO;
    
    if (tokenType && accessToken)
    {
        NSString* headerValue = [NSString stringWithFormat:@"%@ %@", tokenType, accessToken];
        DLog(@"Loading header: %@ %@", NJI_HEADER_AUTHORIZATION, headerValue);
        [self setValue:headerValue forHTTPHeaderField:NJI_HEADER_AUTHORIZATION];
        success = YES;
    }
    
    return success;
}

- (void)dealloc
{
    //Remove observer to access token update
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NJI_NOTIFICATION_ACCESS_TOKEN_UPDATED object:nil];
}

@end
