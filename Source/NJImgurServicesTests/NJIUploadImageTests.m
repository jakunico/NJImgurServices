//
//  NJIUploadImageTests.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadImageTests.h"
#import "NJIController.h"
#import "NJIDateUtils.h"
#import "NJITestConstants.h"

@interface NJIUploadImageTests () <NJIUploadDelegate>

@property (nonatomic)           NJIResponseStatus               error;
@property (nonatomic, strong)   NJIUploadImageResponse*         uploadResponse;
@property (strong)              NSConditionLock*              	lock;

@end

@implementation NJIUploadImageTests

- (void)testImageUpload
{
    NJIController* controller = [NJIController instance];
    
    STAssertFalse([controller uploadImage:nil withDelegate:nil], @"Upload shouldn't be created if provided nil image");
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"testImage" ofType:@"jpg"];
    
    UIImage *imageToUpload = [UIImage imageWithContentsOfFile:imagePath];
    
    STAssertTrue(imageToUpload != nil, @"Test image could not be obtained");
    
    NJIUpload *upload = [[NJIUpload alloc] initWithImage:imageToUpload];
    
    STAssertTrue(upload != nil, @"Upload object could not be obtained");
    
    [controller setClientId:nil clientSecret:nil];
    
    STAssertFalse([controller uploadImage:upload withDelegate:self], @"Upload shouldn't start without a clientId and clientSecret");
    
    [controller setClientId:NJITest_Client_Id clientSecret:NJITest_Client_Secret];
    
    STAssertTrue([controller uploadImage:upload withDelegate:self], @"Unable to start upload");
    
    //Lock thread until we get a response
    self.lock = [[NSConditionLock alloc] init];
    [self.lock lockWhenCondition:1];
    
    STAssertEquals(self.error, NJIResponseStatusEverythingOkay, @"Unable to upload file");
    
    STAssertNotNil(self.uploadResponse, @"Upload Response is nil");
    STAssertNotNil(self.uploadResponse.link, @"Image link is nil");
    
    STAssertTrue(self.uploadResponse.credits.userLimit != 0, @"User-limit did not load");
    STAssertTrue(self.uploadResponse.credits.userRemaining != 0, @"User-remaining did not load");
    STAssertTrue(self.uploadResponse.credits.clientLimit != 0, @"Client-limit did not load");
    STAssertTrue(self.uploadResponse.credits.clientRemaining != 0, @"Client-remaining did not load");
    STAssertTrue(self.uploadResponse.credits.userReset != nil, @"User-reset did not load");
}

- (void)failedToUploadImage:(NJIUpload *)image withError:(NJIResponseStatus)error
{
    self.error = error;
    [self.lock unlockWithCondition:1];
}

- (void)finishedUploadingImage:(NJIUpload *)image withResult:(NJIUploadImageResponse *)uploadResponse
{
    self.error = NJIResponseStatusEverythingOkay;
    self.uploadResponse = uploadResponse;
    [self.lock unlockWithCondition:1];
}

@end
