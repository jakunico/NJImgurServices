//
//  NJIBaseResponse.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJICredits.h"

@interface NJIBaseResponse : NSObject

@property (nonatomic, readonly) NJICredits*     credits;

- (id)initWithDictionary:(NSDictionary *)dictionary responseHTTPHeaders:(NSDictionary*)headers;

@end
