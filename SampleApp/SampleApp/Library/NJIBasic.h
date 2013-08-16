//
//  NJIBasic.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIApiModelObject.h"

/**
 @see http://api.imgur.com/models/basic
 */
@interface NJIBasic : NJIApiModelObject

@property (nonatomic, readonly) id          data;
@property (nonatomic, readonly) BOOL        success;
@property (nonatomic, readonly) NSUInteger  HTTPStatusCode;

@end
