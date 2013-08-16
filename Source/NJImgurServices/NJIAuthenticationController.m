//
//  NJIAuthenticationController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIAuthenticationController.h"
#import "NJIAPIEndpoints.h"
#import "NJIController.h"
#import "NJIRequestParameter.h"
#import "NJIDateUtils.h"
#import "NJINotifications.h"
#import "NJIFileManagerController.h"
#import "PDKeychainBindingsController.h"

#define NJI_AUTHENTICATION_PARAMETER_ACCESS_TOKEN       @"access_token"
#define NJI_AUTHENTICATION_PARAMETER_EXPIRES_IN         @"expires_in"
#define NJI_AUTHENTICATION_PARAMETER_TOKEN_TYPE         @"token_type"
#define NJI_AUTHENTICATION_PARAMETER_REFRESH_TOKEN      @"refresh_token"
#define NJI_AUTHENTICATION_PARAMETER_USERNAME           @"account_username"

@interface NJIAuthenticationController ()

@property (nonatomic, readwrite, copy) NJILoggedUser*    loggedUser;

@end

@implementation NJIAuthenticationController

+ (NJIAuthenticationController*)instance
{
    static NJIAuthenticationController *sharedInstance;
    
    if (!sharedInstance) {
        sharedInstance = [[NJIAuthenticationController alloc] initPrivate];
    }
    
    return sharedInstance;
}

- (id)init
{
    return nil;
}

- (id)initPrivate
{
    self = [super init];
    
    if (self)
    {
        [self loadSessionFromDisk];
    }
    
    return self;
}

- (BOOL)authenticateWithURLString:(NSString*)urlString
{
    if (!urlString)
    {
        return NO;
    }
    
    NSArray* parametersArray = [NJIRequestParameter parametersFromURLString:urlString];
    
    //This parameter array should contain exactly 5 parameters
    if ([parametersArray count] != 5)
    {
        return NO;
    }
    
    NSString* username = nil;
    NSString* accessToken = nil;
    NSString* refreshToken = nil;
    NSString* tokenType = nil;
    NSDate* expirationDate = nil;

    
    for (NJIRequestParameter *parameter in parametersArray)
    {
        if ([parameter.key isEqualToString:NJI_AUTHENTICATION_PARAMETER_ACCESS_TOKEN])
        {
            accessToken = parameter.value;
        }
        else if ([parameter.key isEqualToString:NJI_AUTHENTICATION_PARAMETER_EXPIRES_IN])
        {
            expirationDate = [NJIDateUtils addSeconds:[parameter.value intValue] toDate:[NSDate date]];
        }
        else if ([parameter.key isEqualToString:NJI_AUTHENTICATION_PARAMETER_REFRESH_TOKEN])
        {
            refreshToken = parameter.value;
        }
        else if ([parameter.key isEqualToString:NJI_AUTHENTICATION_PARAMETER_TOKEN_TYPE])
        {
            tokenType = parameter.value;
        }
        else if ([parameter.key isEqualToString:NJI_AUTHENTICATION_PARAMETER_USERNAME])
        {
            username = parameter.value;
        }
    }
    
    //Validate that all 5 keys are now set
    BOOL allKeysSet = (accessToken != nil &&
                       expirationDate != nil &&
                       refreshToken != nil &&
                       tokenType != nil &&
                       username != nil);
    
    if (!allKeysSet)
    {
        DLog(@"Failed to login user, one of the keys is missing");
        self.loggedUser = nil;
    }
    else
    {
        //Create NJILoggedUser object
        self.loggedUser = [[NJILoggedUser alloc] initWithUsername:username];
        
        [self.loggedUser setAccessToken:accessToken
                           refreshToken:refreshToken
                         expirationDate:expirationDate
                              tokenType:tokenType];
        
        //Save the session to disk
        [self saveSessionToDisk];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NJI_NOTIFICATION_ACCESS_TOKEN_UPDATED object:nil];
    }
    
    return self.loggedUser != nil;
}

- (void)logout
{
    [self deleteSessionFromDisk];
    
    self.loggedUser = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NJI_NOTIFICATION_LOGOUT object:nil];
}

- (BOOL)updateCredentialsTo:(NJIRefreshTokenResponse*)newCredentials
{
    if (!newCredentials)
    {
        return NO;
    }
    
    //Verify that all keys have been set
    if (newCredentials.accessToken == nil ||
        newCredentials.refreshToken == nil ||
        newCredentials.expirationDate == nil ||
        newCredentials.tokenType == nil ||
        newCredentials.accountUsername == nil)
    {
        return NO;
    }
    
    //Check that the user is the same
    if (![self.loggedUser.username isEqualToString:newCredentials.accountUsername])
    {
        //User is not the same
        //This should never happen actually, if we're refreshing the access token it means that the user should remain the same, right?
        return NO;
    }

    //Everything seems to be just fine! set the new keys
    [self.loggedUser setAccessToken:newCredentials.accessToken
                       refreshToken:newCredentials.refreshToken
                     expirationDate:newCredentials.expirationDate
                          tokenType:newCredentials.tokenType];
    
    DLog(@"Credentials refreshed!");
    
    //Save session
    [self saveSessionToDisk];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NJI_NOTIFICATION_ACCESS_TOKEN_UPDATED object:nil];
    
    return YES;
}

#pragma mark - Session Persistence methods -
#pragma mark -

- (void)loadSessionFromDisk
{
    self.loggedUser = [[NJILoggedUser alloc] initFromDisk];
    
    if (self.loggedUser)
    {
        DLog(@"Loaded session from disk: %@", self.loggedUser.username);
    }
    else
    {
        DLog(@"Couldn't find a session in disk");
    }
}

- (void)saveSessionToDisk
{
    [self.loggedUser saveSessionToDisk];
    
    DLog(@"Saved session to disk: %@", self.loggedUser.username);
}

- (void)deleteSessionFromDisk
{
    [self.loggedUser removeSessionFromDisk];

    DLog(@"Deleted session from disk");
}

@end
