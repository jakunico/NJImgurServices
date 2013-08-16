//
//  ViewController.m
//  SampleApp
//
//  Created by Nicolas Jakubowski on 8/15/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "ViewController.h"
#import "NJIController.h"

@interface ViewController () <NJIUploadDelegate, NJILoginDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NJIController instance] setClientId:@""
                             clientSecret:@""];
    
    [[NJIController instance] setOAuthCallbackURL:@""];
    
    NJILoggedUser* loggedUser = [[NJIController instance] loggedUser];
    
    if (loggedUser)
    {
        self.userLabel.text = [NSString stringWithFormat:@"Logged user: %@", loggedUser.username];
    }
    else
    {
        self.userLabel.text = @"No user is logged in";
    }
    
    [[NJIController instance] addObserverToLogoutNotification:self selector:@selector(logoutNotification)];
    
}

- (void)logoutNotification
{
    self.userLabel.text = @"No user is logged in";
}

- (IBAction)actionLogin:(id)sender
{
    [[NJIController instance] loginWithParentViewController:self andDelegate:self];
}

- (IBAction)actionLogout:(id)sender
{
    [[NJIController instance] logout];
}

- (IBAction)actionUploadImage:(id)sender
{
    NJIUpload *upload = [[NJIUpload alloc] initWithImage:self.imageView.image];
    
    if ([[NJIController instance] uploadImage:upload withDelegate:self])
    {
        self.statusLabel.text = @"Uploading...";
    }
    else
    {
        self.statusLabel.text = @"Failed to create upload";
    }
}

#pragma mark NJILoginDelegate methods

- (void)loginInterfaceDidAppear
{
    NSLog(@"loginInterfaceDidAppear");
}

- (void)loginInterfaceDidDisappear
{
    NSLog(@"loginInterfaceDidDisappear");
}

- (void)loginCancelled
{
    NSLog(@"loginCancelled");
}

- (void)successfullyLoggedInUser:(NJILoggedUser*)loggedUser
{
    self.userLabel.text = [NSString stringWithFormat:@"Logged user: %@", loggedUser.username];
}

#pragma mark NJIUploadDelegate methods

- (void)finishedUploadingImage:(NJIUpload*)image withResult:(NJIUploadImageResponse*)uploadResponse
{
    self.statusLabel.text = uploadResponse.link;
}

- (void)failedToUploadImage:(NJIUpload*)image withError:(NJIResponseStatus)error
{
    if (error == NJIResponseStatusRequestTimedOut)
    {
        self.statusLabel.text = @"Unable to upload. Your connection seems to be extremely slow.";
    }
    else if (error == NJIResponseStatusMissingInternetConnection)
    {
        self.statusLabel.text = @"Unable to upload. Check your connection.";
    }
    else
    {
        self.statusLabel.text = @"Unable to upload. Please try again later";
    }
}

@end
