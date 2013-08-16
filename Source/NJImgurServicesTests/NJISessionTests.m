//
//  NJISessionTests.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 7/21/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJISessionTests.h"
#import "NJIController.h"
#import "NJITestConstants.h"
#import "NJILoginViewController.h"
#import "NJIAuthenticationController.h"

@interface NJISessionTests ()

@end

@implementation NJISessionTests

- (void)testLogin
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"testImage" ofType:@"jpg"];
    UIImage *imageToUpload = [UIImage imageWithContentsOfFile:imagePath];
    
    NJIUpload* upload = [[NJIUpload alloc] initWithImage:imageToUpload];
    
    STAssertFalse([[NJIController instance] uploadImage:upload withDelegate:nil], @"Upload should not start if I set a clientId or clientSecret with length=0");
    
    [[NJIController instance] setClientId:@"" clientSecret:@""];
    
    STAssertFalse([[NJIController instance] uploadImage:upload withDelegate:nil], @"Upload should not start if I set a clientId or clientSecret with length=0");
    
    STAssertFalse([[NJIController instance] loginWithParentViewController:[[UIViewController alloc] init] andDelegate:nil], @"Login interface should not appear without setting a callback URL");
    
    [[NJIController instance] setOAuthCallbackURL:@""];
    
    STAssertFalse([[NJIController instance] loginWithParentViewController:[[UIViewController alloc] init] andDelegate:nil], @"Login interface should not appear without setting a callback URL");
    
    [[NJIController instance] setClientId:NJITest_Client_Id clientSecret:NJITest_Client_Secret];
    
    [[NJIController instance] setOAuthCallbackURL:@"http://njtestapplicationcallback.com/"];
    
    [[NJIController instance] logout];
    
    NJILoginViewController *loginViewController = [[NJILoginViewController alloc] initWithDelegate:nil];
    
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://njtestapplicationcallback.com/#access_token=cebb42b87843cd0f48fc4b8216ca760ff99f0f8b&expires_in=3600&token_type=bearer&refresh_token=c38f1afbdcbf6e009cf86429a053c72a243a0285&account_username=njaku"]];
    
    //We're going to simulate a redirect URL
    [loginViewController performSelector:@selector(webViewShouldStartLoadingRequest:) withObject:mutableURLRequest];
    
    STAssertNotNil([[NJIController instance] loggedUser], @"Logged user is nil");
    STAssertEqualObjects(@"cebb42b87843cd0f48fc4b8216ca760ff99f0f8b", [[NJIController instance] loggedUser].accessToken, @"Access token does not match with the token sent in the redirect URL");
    STAssertEqualObjects(@"c38f1afbdcbf6e009cf86429a053c72a243a0285", [[NJIController instance] loggedUser].refreshToken, @"Refresh token does not match with the token sent in the redirect URL");
    
    //Now check that session is correctly loaded when allocating a new NJIController instance (simulating the startup of the application)
    STAssertNotNil([[[NJIController alloc] performSelector:@selector(initPrivate) withObject:nil] loggedUser], @"Failed to load session from disk");
    
    //Now check that logout works
    [[NJIController instance] logout];
    STAssertNil([[NJIController instance] loggedUser], @"Logged user wasn't deleted after logout");
    
    //Check that a new instance of NJIController doesn't return a logged user either. This will check that session is being correctly removed from disk / keychain / wherever we're saving it
    
    STAssertNil([[[NJIController alloc] performSelector:@selector(initPrivate) withObject:nil] loggedUser], @"Session wasn't correctly removed from disk");
    
}

@end
