//
//  NJIDateUtils.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIDateUtils : NSObject

/**
 Adds the provided number of seconds to the given date
 @param seconds The number of seconds to add
 @param date The date to add those seconds to
 @return The new date object with the added seconds
 @discussion Seconds may be negative, it will return a date object that is older in time than the provided date parameter.
 */
+ (NSDate*)addSeconds:(int)seconds toDate:(NSDate*)date;

@end
