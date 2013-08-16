//
//  NJIUser.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIUser : NSObject <NSCopying>

@property (nonatomic, readonly, copy) NSString*   username;

- (id)initWithUsername:(NSString*)username;

@end
