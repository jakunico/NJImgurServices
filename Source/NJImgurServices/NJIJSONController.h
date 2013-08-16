//
//  NJIJSONResponseController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/25/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIJSONController : NSObject

+ (NSDictionary*)dictionaryFromJSONData:(NSData*)data;

@end
