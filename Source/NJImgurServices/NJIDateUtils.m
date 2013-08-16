//
//  NJIDateUtils.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIDateUtils.h"

@implementation NJIDateUtils

+ (NSDate*)addSeconds:(int)seconds toDate:(NSDate*)date
{
    return [date dateByAddingTimeInterval:seconds];
}

@end
