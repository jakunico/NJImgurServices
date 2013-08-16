//
//  ViewController.m
//  ImgurApp
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "ViewController.h"
#import "NJIController.h"

@interface ViewController () <NJIUploadDelegate, NJILoginDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;
@property (weak, nonatomic) IBOutlet UILabel *loggedUserLabel;

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
        self.loggedUserLabel.text = [NSString stringWithFormat:@"Logged user: %@", loggedUser.username];
    }
    else
    {
        self.loggedUserLabel.text = @"No user is logged in";
    }
    
    [[NJIController instance] addObserverToLogoutNotification:self selector:@selector(logoutNotification)];
}

- (IBAction)actionUploadImage:(id)sender
{
    NJIUpload *upload = [[NJIUpload alloc] initWithImage:self.imageView.image];
    
    if ([[NJIController instance] uploadImage:upload withDelegate:self])
    {
        self.linkLabel.text = @"Upload added";
    }
    else
    {
        self.linkLabel.text = @"Failed to add upload";
    }

}

- (IBAction)actionLogin:(id)sender
{
    if ([[NJIController instance] loginWithParentViewController:self
                                                     andDelegate:self])
    {
        NSLog(@"Login appeared");
    }
    else
    {
        NSLog(@"Login failed");
    }
}

- (IBAction)actionLogout:(id)sender
{
    [[NJIController instance] logout];
}

#pragma mark NJIUploadDelegate methods

- (void)failedToUploadImage:(NJIUpload *)image withError:(NJIResponseStatus)error
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.linkLabel.text = @"Failed to upload";
    }];

}

- (void)finishedUploadingImage:(NJIUpload *)image withResult:(NJIUploadImageResponse *)uploadResponse
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.linkLabel.text = uploadResponse.link;
    }];
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
    self.loggedUserLabel.text = [NSString stringWithFormat:@"Logged user: %@", loggedUser.username];
}

#pragma mark NJIController Logout Notifications

- (void)logoutNotification
{
    NSLog(@"Logout notification received");
    self.loggedUserLabel.text = @"No user is logged in";
}

@end
