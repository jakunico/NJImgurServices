//
//  NJIApiModelObject.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIResponseObject.h"

/**
 Any object defined in the Imgur Model needs to inherit from this class
 @see http://api.imgur.com/models
 */
@interface NJIApiModelObject : NSObject  <NJIResponseObject>

@property (nonatomic, readonly) NSDictionary*     JSONDictionary;

/**
 Use this method to initialize the representation of the Imgur's Model in our project
 @param data The JSON representation of the object
 @discussion If an invalid JSON is provided, this method will return nil
 @discussion If there's a problem parsing the JSON, we'll return nil
 */
- (id)initWithJSONData:(NSData*)data;

@end
