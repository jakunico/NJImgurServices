//
//  NJICreditsRequest.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 8/5/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJICreditsRequest.h"
#import "NJIAPIEndpoints.h"
#import "NJIConstants.h"

@implementation NJICreditsRequest

- (id)init
{
    NSURL* creditsURL = [NJIAPIEndpoints creditsURL];
    
    self = [super initWithURL:creditsURL];
    
    if (self) {
        
        self.HTTPMethod = NJI_HTTP_METHOD_GET;
        
    }
    return self;
}

@end
