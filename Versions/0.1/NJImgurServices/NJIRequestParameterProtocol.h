//
//  NJIRequestParameterProtocol.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 If your class can be sent to the server, implement this protocol.
 */
@protocol NJIRequestParameterProtocol <NSObject>

@required

/**
 An array of NJIRequestParameter objects that will be sent in the request to the server.
 */
- (NSArray*)parametersForRequest;

@end
