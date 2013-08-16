//
//  NJIUploadImageTimeoutTests.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadImageTimeoutTests.h"
#import "NJITestConstants.h"
#import "NJIController.h"

@interface NJIUploadImageTimeoutTests () <NJIUploadDelegate>

@property (nonatomic, strong) NSConditionLock*          lock;

@end

@implementation NJIUploadImageTimeoutTests

- (void)testTimeout
{
    [[NJIController instance] setClientId:NJITest_Client_Id clientSecret:NJITest_Client_Secret];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *imagePath = [bundle pathForResource:@"testImage" ofType:@"jpg"];
    
    UIImage *imageToUpload = [UIImage imageWithContentsOfFile:imagePath];
    
    STAssertNotNil(imageToUpload, @"Image to upload can't be nil");
    
    NJIUpload *upload = [[NJIUpload alloc] initWithImage:imageToUpload];
    
    STAssertNotNil(upload, @"Could not obtain upload object from image");
    
    STAssertTrue([[NJIController instance] uploadImage:upload withDelegate:self], @"Unable to start upload");
    
    self.lock = [[NSConditionLock alloc] init];
    [self.lock lockWhenCondition:1];
}

- (NSTimeInterval)timeoutIntervalForUpload:(NJIUpload *)image
{
    return 1; //We return a very low timeout period here so we check that timeout feature works fine
}

- (void)finishedUploadingImage:(NJIUpload *)image withResult:(NJIUploadImageResponse *)uploadResponse
{
    STFail(@"Image shouldn't have been uploaded");
    [self.lock unlockWithCondition:1];
}

- (void)failedToUploadImage:(NJIUpload *)image withError:(NJIResponseStatus)error
{
    STAssertEquals(error, NJIResponseStatusRequestTimedOut, @"Didn't fail because of timeout error");
    [self.lock unlockWithCondition:1];
}

@end
