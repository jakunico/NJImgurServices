//
//  NJICredits.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 8/5/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class is used to store the credit limits.
 @see http://api.imgur.com/#limits
 */
@interface NJICredits : NSObject

/**
 Total credits that can be allocated (X-RateLimit-UserLimit).
 */
@property (nonatomic, readonly) NSUInteger        userLimit;

/**
 Total credits available (X-RateLimit-UserRemaining).
 */
@property (nonatomic, readonly) NSUInteger        userRemaining;

/**
 When the credits will be reset (X-RateLimit-UserReset).
 */
@property (nonatomic, strong, readonly) NSDate*   userReset;

/**
 Total credits that can be allocated for the application in a day (X-RateLimit-ClientLimit).
 */
@property (nonatomic, readonly) NSUInteger        clientLimit;

/**
 Total credits remaining for the application in a day (X-RateLimit-ClientRemaining).
 */
@property (nonatomic, readonly) NSUInteger        clientRemaining;

/**
 Use this method to initialize the class with the HTTP headers dictionary
 @param dictionary The dictionary containing the HTTP headers.
 @return The new initialized instance
 */
- (id)initWithHeaders:(NSDictionary*)dictionary;

/**
 Use this method to obtain an instance of NJICredits from an HTTP headers dictionary
 @see [NJICredits initWithHeaders:]
 */
+ (NJICredits*)creditsWithHeaders:(NSDictionary*)dictionary;

@end
