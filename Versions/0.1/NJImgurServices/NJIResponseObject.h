//
//  NJIResponseObject.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This protocol should be implemented by those classes that exist on the server
 */
@protocol NJIResponseObject <NSObject>

@required

/**
 This method is used to initialize your class object from the JSON data returned by the server.
 @param data The JSON response sent by the server.
 */
- (id)initWithJSONData:(NSData*)data;

@end
