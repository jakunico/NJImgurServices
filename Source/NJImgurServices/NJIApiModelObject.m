//
//  NJIApiModelObject.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIApiModelObject.h"
#import "NJIJSONController.h"

@interface NJIApiModelObject ()

@property (nonatomic, strong) NSDictionary*     JSONDictionary;

@end

@implementation NJIApiModelObject

- (id)initWithJSONData:(NSData*)data
{
    if (!data) return nil;
    
    NSError *error = nil;
    
    self.JSONDictionary = [NJIJSONController dictionaryFromJSONData:data];
    
    if (self.JSONDictionary == nil || error != nil)
    {
        //Something is wrong with this JSON
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}

@end
