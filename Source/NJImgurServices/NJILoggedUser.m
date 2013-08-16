//
//  NJILoggedUser.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJILoggedUser.h"
#import "PDKeychainBindingsController.h"

#define NJI_CODING_KEY_USERNAME         @"username"
#define NJI_CODING_KEY_ACCESS_TOKEN     @"accessToken"
#define NJI_CODING_KEY_REFRESH_TOKEN    @"refreshToken"
#define NJI_CODING_KEY_EXPIRATION_DATE  @"expirationDate"
#define NJI_CODING_KEY_TOKEN_TYPE       @"tokenType"

@interface NJILoggedUser () <NSCopying>

@end

@implementation NJILoggedUser

- (id)initFromDisk;
{
    NSString* username = [[NSUserDefaults standardUserDefaults] objectForKey:NJI_CODING_KEY_USERNAME];
    
    self = [self initWithUsername:username];
    
    if (self)
    {
        NSString *accessToken = [[PDKeychainBindingsController sharedKeychainBindingsController] stringForKey:NJI_CODING_KEY_ACCESS_TOKEN];
        NSString *refreshToken = [[PDKeychainBindingsController sharedKeychainBindingsController] stringForKey:NJI_CODING_KEY_REFRESH_TOKEN];
        NSDate *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:NJI_CODING_KEY_EXPIRATION_DATE];
        NSString *tokenType = [[NSUserDefaults standardUserDefaults] objectForKey:NJI_CODING_KEY_TOKEN_TYPE];
        
        [self setAccessToken:accessToken refreshToken:refreshToken expirationDate:expirationDate tokenType:tokenType];
    }
    
    return self;
}


- (void)setAccessToken:(NSString *)accessToken
          refreshToken:(NSString*)refreshToken
        expirationDate:(NSDate*)expirationDate
             tokenType:(NSString*)tokenType
{
    DLog(@"Will set access token: %@", accessToken);
    DLog(@"Will set refresh token: %@", refreshToken);
    DLog(@"Will set expiration date: %@", expirationDate);
    DLog(@"Will set token type: %@", [tokenType capitalizedString]);
    
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _expirationDate = expirationDate;
    _tokenType = [tokenType capitalizedString];
}

#pragma mark - NSCopying Protocol Methods -
#pragma mark -

- (id)copyWithZone:(NSZone *)zone
{
    NJILoggedUser* loggedUserCopy = [super copyWithZone:zone];
    loggedUserCopy->_accessToken = [self.accessToken copyWithZone:zone];
    loggedUserCopy->_expirationDate = [self.expirationDate copyWithZone:zone];
    loggedUserCopy->_refreshToken = [self.refreshToken copyWithZone:zone];
    loggedUserCopy->_tokenType = [self.tokenType copyWithZone:zone];
    
    return loggedUserCopy;
}

#pragma mark - Session storage in disk Methods
#pragma mark -

- (void)saveSessionToDisk
{
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:self.accessToken forKey:NJI_CODING_KEY_ACCESS_TOKEN];
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:self.refreshToken forKey:NJI_CODING_KEY_REFRESH_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.expirationDate forKey:NJI_CODING_KEY_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] setObject:self.tokenType forKey:NJI_CODING_KEY_TOKEN_TYPE];
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:NJI_CODING_KEY_USERNAME];
}

- (void)removeSessionFromDisk
{
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:nil forKey:NJI_CODING_KEY_ACCESS_TOKEN];
    [[PDKeychainBindingsController sharedKeychainBindingsController] storeString:nil forKey:NJI_CODING_KEY_REFRESH_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NJI_CODING_KEY_EXPIRATION_DATE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NJI_CODING_KEY_TOKEN_TYPE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:NJI_CODING_KEY_USERNAME];
}

@end
