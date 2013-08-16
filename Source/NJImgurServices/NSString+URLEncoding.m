//
//  NSString+URLEncoding.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

- (NSString*)urlEncode
{
    return [self urlEncodeUsingEncoding:kCFStringEncodingUTF8];
}

//Taken from http://stackoverflow.com/questions/9831108/add-fields-to-nsmutableurlrequest
- (NSString*)urlEncodeUsingEncoding:(CFStringEncoding)encoding
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                     encoding));
}

@end
