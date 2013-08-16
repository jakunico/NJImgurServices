//
//  NJICredits.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 8/5/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJICredits.h"

#define NJI_HEADER_USER_LIMIT       @"X-RateLimit-UserLimit"
#define NJI_HEADER_USER_REMAINING   @"X-RateLimit-UserRemaining"
#define NJI_HEADER_USER_RESET       @"X-RateLimit-UserReset"
#define NJI_HEADER_CLIENT_LIMIT     @"X-RateLimit-ClientLimit"
#define NJI_HEADER_CLIENT_REMAINING @"X-RateLimit-ClientRemaining"

@interface NJICredits ()

@property (nonatomic) NSUInteger        userLimit;
@property (nonatomic) NSUInteger        userRemaining;
@property (nonatomic, strong) NSDate*   userReset;
@property (nonatomic) NSUInteger        clientLimit;
@property (nonatomic) NSUInteger        clientRemaining;

@end

@implementation NJICredits

#pragma mark Public Methods
#pragma mark -

- (id)initWithHeaders:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self)
    {
        
        @try {
            
            self.userLimit = [[dictionary objectForKey:NJI_HEADER_USER_LIMIT] intValue];
            self.userRemaining = [[dictionary objectForKey:NJI_HEADER_USER_REMAINING] intValue];
            self.clientLimit = [[dictionary objectForKey:NJI_HEADER_CLIENT_LIMIT] intValue];
            self.clientRemaining = [[dictionary objectForKey:NJI_HEADER_CLIENT_REMAINING] intValue];
            
            
            self.userReset = [[NSDate alloc] initWithTimeIntervalSince1970:[[dictionary objectForKey:NJI_HEADER_USER_RESET] intValue]];
            
        }
        @catch (NSException *exception) {
            DLog(@"Exception found: %@", [exception description]);
            self = nil;
        }
        
        //Check that there is at least one field loaded
        if (!self.userLimit && !self.userReset && !self.userRemaining && !self.clientRemaining && !self.clientLimit)
        {
            DLog(@"Couldn't load credits from last request");
            self = nil;
        }
        else
        {
            DLog(@"Credits: %@", self);
        }
        
    }
    
    return self;
}

+ (NJICredits*)creditsWithHeaders:(NSDictionary *)dictionary
{
    return [[NJICredits alloc] initWithHeaders:dictionary];
}

#pragma mark Private Methods
#pragma mark -

- (NSString*)description
{
    return [NSString stringWithFormat:@"\n%@: %i\n%@: %i\n%@: %i\n%@: %i\n%@: %@\n",
            NJI_HEADER_USER_LIMIT, self.userLimit,
            NJI_HEADER_USER_REMAINING, self.userRemaining,
            NJI_HEADER_CLIENT_LIMIT, self.clientLimit,
            NJI_HEADER_CLIENT_REMAINING, self.clientRemaining,
            NJI_HEADER_USER_RESET, self.userReset];
}

@end
