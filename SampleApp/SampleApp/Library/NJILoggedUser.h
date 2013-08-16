//
//  NJILoggedUser.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUser.h"

@interface NJILoggedUser : NJIUser

@property (nonatomic, readonly) NSString*       accessToken;
@property (nonatomic, readonly) NSString*       refreshToken;
@property (nonatomic, readonly) NSDate*         expirationDate;
@property (nonatomic, readonly) NSString*       tokenType;

/**
 Use this method to initialize a NJILoggedUser with the stored data on disk
 */
- (id)initFromDisk;

/**
 Use this method to set new tokens for the logged user
 */
- (void)setAccessToken:(NSString *)accessToken
          refreshToken:(NSString*)refreshToken
        expirationDate:(NSDate*)expirationDate
             tokenType:(NSString*)tokenType;

/**
 Saves the session in disk
 */
- (void)saveSessionToDisk;

/**
 Removes the session from disk
 */
- (void)removeSessionFromDisk;

@end
