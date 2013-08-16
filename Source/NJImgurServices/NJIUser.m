//
//  NJIUser.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUser.h"

@interface NJIUser ()

@property (nonatomic, copy) NSString*     username;

@end

@implementation NJIUser

- (id)initWithUsername:(NSString*)username
{
    if (!username)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        self.username = username;
    }
    
    return self;
}

#pragma mark - NSCopying Protocol Methods -
#pragma mark -

- (id)copyWithZone:(NSZone *)zone
{
    NJIUser* userCopy = [[[self class] allocWithZone:zone] initWithUsername:[self.username copyWithZone:zone]];
    return userCopy;
}

@end
