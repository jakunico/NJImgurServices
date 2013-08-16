//
//  NJILoginDelegate.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJILoggedUser.h"
#import "NJIResponseStatus.h"

/**
 Use this delegate to be informed about login flow
 */
@protocol NJILoginDelegate <NSObject>

/**
 Called when the login interface appears in screen
 @discussion This method is always called in the main thread
 */
- (void)loginInterfaceDidAppear;

/**
 Called when the login interface disappears from screen
 @discussion This method is always called in the main thread
 */
- (void)loginInterfaceDidDisappear;

/**
 Called when the user presses the cancel button
 @discussion This method is always called in the main thread
 */
- (void)loginCancelled;

/**
 Called when the login is done successfully
 @param loggedUser The user that logged in
 @discussion This method is always called in the main thread
 */
- (void)successfullyLoggedInUser:(NJILoggedUser*)loggedUser;

@end
