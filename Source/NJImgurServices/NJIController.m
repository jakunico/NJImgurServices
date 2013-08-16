//
//  NJIController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIController.h"
#import "NJIUploadController.h"
#import "NJILoginViewController.h"
#import "NJIAuthenticationController.h"
#import "NJINotifications.h"
#import "NJIFileManagerController.h"
#import "NJIJSONController.h"

@interface NJIController ()

@property (nonatomic, strong) NSString*                 clientId;
@property (nonatomic, strong) NSString*                 clientSecret;
@property (nonatomic, strong) NSString*                 callbackURL;
@property (nonatomic, strong) NJILoginViewController*   loginViewController;

/**
 This method verifies that setup of the library is done correctly.
 @return YES if setup is done correctly, NO otherwise.
 */
- (BOOL)setupDoneCorrectly;

@end

@implementation NJIController

+ (NJIController*)instance
{
    static NJIController* instance;
    
    if (!instance) {
        instance = [[NJIController alloc] initPrivate];
    }
    
    return instance;
}

- (id)initPrivate
{
    self = [super init];
    
    if (self)
    {   

    }
    
    return self;
}

- (id)init
{
    return nil;
}

- (BOOL)setupDoneCorrectly
{
    BOOL success = YES;
    
    //Verify that clientId and clientSecret are set
    if (self.clientId == nil || self.clientSecret == nil || [self.clientId length] == 0 || [self.clientSecret length] == 0)
    {
        NSLog(@"A valid clientId and clientSecret is required. Use [NJIController setClientId:clientSecret:].");
        success = NO;
    }
    
    return success;
}

- (void)setClientId:(NSString*)clientId clientSecret:(NSString*)clientSecret
{
    self.clientId = clientId;
    self.clientSecret = clientSecret;
}

#pragma mark - Upload Image methods -

- (BOOL)uploadImage:(NJIUpload*)image withDelegate:(id<NJIUploadDelegate>)delegate
{
    if ([self setupDoneCorrectly] == NO)
    {
        return NO;
    }
    
    return [[NJIUploadController instance] addUpload:image withDelegate:delegate];
}

- (BOOL)uploadImages:(NSArray*)images withDelegate:(id<NJIUploadDelegate>)delegate
{
    if ([self setupDoneCorrectly] == NO)
    {
        return NO;
    }
    
    return [[NJIUploadController instance] addUploads:images withDelegate:delegate];
}

- (void)cancelAllUploads
{
    [[NJIUploadController instance] cancelAllUploads];
}

#pragma mark - Authroization / Login methods -
#pragma mark -

- (void)setOAuthCallbackURL:(NSString*)callbackURL
{
    self.callbackURL = callbackURL;
}

- (void)dismissLoginInterface
{
    [self.loginViewController dismissViewControllerAnimated:YES completion:^
    {
        if ([self.loginViewController.delegate respondsToSelector:@selector(loginInterfaceDidDisappear)])
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.loginViewController.delegate loginInterfaceDidDisappear];
            }];
        }
        
        self.loginViewController = nil;
    }];
}

- (BOOL)loginWithParentViewController:(UIViewController*)viewController andDelegate:(id<NJILoginDelegate>)delegate
{
    if ([self setupDoneCorrectly] == NO)
    {
        return NO;
    }
    
    if (self.callbackURL == nil || [self.callbackURL length] == 0)
    {
        NSLog(@"A valid callbackURL is required. Use [NJIController setOAuthCallbackURL:].");
        return NO;
    }
    
    if (self.loginViewController != nil)
    {
        NSLog(@"The login interface is currently visible. Use [NJIController dismissLoginInterface].");
        return NO;
    }
    
    if ([self loggedUser] != nil)
    {
        NSLog(@"A user is already logged in. Use [NJIController logout] to delete the session before presenting the login interface.");
        return NO;
    }
    
    if (![viewController isKindOfClass:[UIViewController class]])
    {
        NSLog(@"A valid UIViewController is required");
        return NO;
    }
    
    self.loginViewController = [[NJILoginViewController alloc] initWithDelegate:delegate];
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:self.loginViewController];

    [viewController presentViewController:navigationController animated:YES completion:^
    {
        if ([self.loginViewController.delegate respondsToSelector:@selector(loginInterfaceDidAppear)])
        {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.loginViewController.delegate loginInterfaceDidAppear];
            }];
        }
    }];
    
    return YES;
}

- (NJILoggedUser*)loggedUser
{
    return [[NJIAuthenticationController instance] loggedUser];
}

- (void)logout
{
    [[NJIAuthenticationController instance] logout];
}

- (void)addObserverToLogoutNotification:(id)target selector:(SEL)selector
{
    if (!target || !selector)
    {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:target selector:selector name:NJI_NOTIFICATION_LOGOUT object:nil];
}

- (void)removeObserverToLogoutNotification:(id)target
{
    [[NSNotificationCenter defaultCenter] removeObserver:target name:NJI_NOTIFICATION_LOGOUT object:nil];
}

- (void)continueUnfinishedUploadsInBackground
{
    [[NJIUploadController instance] beginBackgroundTask];
}

@end
