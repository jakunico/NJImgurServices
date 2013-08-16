//
//  NJIJSONResponseController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/25/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIJSONController.h"

@implementation NJIJSONController

+ (NSDictionary*)dictionaryFromJSONData:(NSData*)data
{
    NSError* error = nil;
    NSDictionary* dictionary = nil;
    
    id parsedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (error)
    {
        DLog(@"Error when parsing JSON: %@", [error localizedDescription]);
    }
    
    if (![parsedObject isKindOfClass:[NSDictionary class]])
    {
        DLog(@"Top level object is not a dictionary as expected");
    }
    else
    {
        dictionary = (NSDictionary*)parsedObject;
    }
    
    return dictionary;
}

@end
