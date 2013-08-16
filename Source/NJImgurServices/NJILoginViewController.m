//
//  NJILoginViewController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/23/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJILoginViewController.h"
#import "NJIAPIEndpoints.h"
#import "NJIController.h"
#import "NJIConstants.h"
#import "NJIAuthenticationController.h"

@interface NJILoginViewController () <UIWebViewDelegate>

@property (nonatomic, strong) id<NJILoginDelegate>  delegate;
@property (nonatomic, strong) UIWebView*            webView;

@end

@implementation NJILoginViewController

- (id)initWithDelegate:(id<NJILoginDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Create the cancel button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(actionCancel)];
    [self showLoading];

    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height)];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.webView];
    
    [self loadAuthorizePage];
}

- (void)loadAuthorizePage
{
    NSURL *authorizeURL = [NJIAPIEndpoints authorizationURLWithClientId:[[NJIController instance] clientId] responseType:NJI_API_AUTHORIZATION_RESPONSE_TYPE_TOKEN];

    [self.webView loadRequest:[NSURLRequest requestWithURL:authorizeURL]];
}

- (void)showRefreshButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                           target:self
                                                                                           action:@selector(actionRefresh)];
}

- (void)hideRefreshButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)actionRefresh
{
    [self loadAuthorizePage];
}

- (void)actionCancel
{
    [self.webView stopLoading];
    [self hideLoading];
        
    if ([self.delegate respondsToSelector:@selector(loginCancelled)])
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.delegate loginCancelled];
        }];
    }
    
    [[NJIController instance] dismissLoginInterface];
}

- (void)showLoading
{
    self.title = @"Loading...";

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)hideLoadingAndShowTitle:(NSString*)title
{
    self.title = title;
    
    [self hideLoading];
}

- (void)hideLoading
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

/**
 This method will analyse the request that the web view wants to load and check:
    - If the user pressed the Deny button, we're going to dismiss the login interface
    - If the user pressed the Allow button, we're not going to do anything.
    - If the web view is going to be redirected to our callback URL, we're going to capture parameters 
 */
- (BOOL)webViewShouldStartLoadingRequest:(NSURLRequest*)request
{
    if ([request.URL.absoluteString hasPrefix:[[NJIController instance] callbackURL]])
    {
        DLog(@"Will process URL: %@", request.URL.absoluteString);
        
        //This is our URL!
        self.webView.delegate = nil; //Stop receiving events from the web view
        
        //If user did hit the Deny button, cancel the login flow
        if ([request.URL.absoluteString rangeOfString:@"error=access_denied"].location != NSNotFound)
        {
            [self actionCancel];
            return NO;
        }
        
        if ([[NJIAuthenticationController instance] authenticateWithURLString:request.URL.absoluteString])
        {
            //Inform the delegate that we have logged in the user
            if ([self.delegate respondsToSelector:@selector(successfullyLoggedInUser:)])
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.delegate successfullyLoggedInUser:[[NJIAuthenticationController instance] loggedUser]];
                }];
            }
            [self hideLoading];
            [[NJIController instance] dismissLoginInterface];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Unable to login"
                                        message:@"We're not sure what happened. Please try again in a few minutes."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil]
             show];
            [[NJIController instance] dismissLoginInterface];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - UIWebViewDelegate methods -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return [self webViewShouldStartLoadingRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideLoadingAndShowTitle:@"Authenticate"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    if ([NSURLErrorDomain isEqualToString:error.domain])
    {
        //This is a weird error actually. I'm seeing that when you press the Allow button multiple times, this error is sent.
        //I'm going to ignore this error because it usually means we're still loading
        return;
    }
    
    [self hideLoadingAndShowTitle:@"Unable to load"];
    
    [self showRefreshButton];
    
    [[[UIAlertView alloc] initWithTitle:@"Unable to load website"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil]
     show];
}

@end
