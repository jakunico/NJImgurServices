//
//  NJIController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NJIUpload.h"
#import "NJIUploadDelegate.h"
#import "NJILoginDelegate.h"

@interface NJIController : NSObject

@property (nonatomic, readonly) NSString*       clientId;
@property (nonatomic, readonly) NSString*       clientSecret;
@property (nonatomic, readonly) NSString*       callbackURL;

/**
 Use this method to obtain an instance of the controller
 @discussion never attemp to alloc/init a controller
 */
+ (NJIController*)instance;

/**
 Use this method to set the clientId and clientSecret
 @param clientId The clientId
 @param clientSecret The clientSecret
 @see https://api.imgur.com/#register
 */
- (void)setClientId:(NSString*)clientId clientSecret:(NSString*)clientSecret;

/**
 Use this method to upload an image
 @param image The image to upload
 @param delegate The delegate of the upload
 @return YES if image was added to the upload queue, NO if something went wrong
 */
- (BOOL)uploadImage:(NJIUpload*)image withDelegate:(id<NJIUploadDelegate>)delegate;

/**
 Use this method to upload multiple images
 @param images An array containing at least one NJIUpload object
 @param delegate The delegate of the upload
 @return YES if all images were added to the upload queue, NO if there was at least one image that failed
 */
- (BOOL)uploadImages:(NSArray*)images withDelegate:(id<NJIUploadDelegate>)delegate;

/**
 Cancells all uploads
 */
- (void)cancelAllUploads;

/**
 Use this method to set the callbackURL you have set when creating your app at https://api.imgur.com/oauth2/addclient
 @param callbackURL The callback URL
 @discussion You must set a callbackURL before presenting the Login interface
 */
- (void)setOAuthCallbackURL:(NSString*)callbackURL;

/**
 Ise this method to dismiss the login interface.
 @discussion If the login interface is not visible, this method will do nothing
 */
- (void)dismissLoginInterface;

/**
 Use this method to present the login interface
 @param viewController The parent view controller
 @param delegate The login delegate
 @return YES if the login interface was presented correctly, NO otherwise
 @discussion You must first use [NJIController setOAuthCallbackURL:] to configure the callback URL. If you don't do so, this method will return NO.
 */
- (BOOL)loginWithParentViewController:(UIViewController*)viewController andDelegate:(id<NJILoginDelegate>)delegate;

/**
 Use this method to obtain the user that is currently logged in
 @return The user that is currently logged in, nil if there is no user logged in
 */
- (NJILoggedUser*)loggedUser;

/**
 Use this method to logout the user
 @discussion When user is logged out, either because he did it or because the access token expired and we were unable to get a new one, an NJILogoutNotification is sent so you are aware of this event. You should update your interface to react accordly to this event. If your applications requires a user to be logged in, if you detect this notification you should prompt your user to login again.
 @discussion The reason we're handling login through an observer and not through the login delegate is because the login delegate is intended to be used only for the login interface. Logout may occurr at any moment.
 @discussion Remember that we'll always attemp to refresh the access token so user doesn't have to login again ever
 @see [NJIController addObserverToLogoutNotification:selector]
 @see [NJIController removeObserverToLogoutNotification]
 */
- (void)logout;

/**
 Use this method to listen to the logout notification
 @param target The target
 @param selector The selector that will be executed when logging out
 @see [NJIController logout]
 */
- (void)addObserverToLogoutNotification:(id)target selector:(SEL)selector;

/**
 Use this method to stop listening to the logout notifications
 @param target The target to remove
 @see [NJIController addObserverToLogoutNotification:selector:]
 */
- (void)removeObserverToLogoutNotification:(id)target;

/**
 Use this method to coninue unfinished uploads while in background
 @discussion You want to call this method in your [AppDelegate applicationDidEnterBackground:]
 */
- (void)continueUnfinishedUploadsInBackground;

@end
