//
//  NSString+URLEncoding.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString*)urlEncode;
- (NSString*)urlEncodeUsingEncoding:(CFStringEncoding)encoding;

@end
