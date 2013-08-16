//
//  NJIBaseResponse.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIBaseResponse.h"

@interface NJIBaseResponse ()

@property (nonatomic, strong) NJICredits*       credits;

@end

@implementation NJIBaseResponse

- (id)initWithDictionary:(NSDictionary *)dictionary responseHTTPHeaders:(NSDictionary*)headers
{
    if (!dictionary)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        
        //Check if there are headers available
        if (headers)
        {
            self.credits = [NJICredits creditsWithHeaders:headers];
        }
        
    }
    
    return self;
}

@end
