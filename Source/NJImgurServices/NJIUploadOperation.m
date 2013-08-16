//
//  NJIUploadOperation.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadOperation.h"
#import "NJIUploadFileRequest.h"
#import "NJIResponseStatus.h"
#import "NJIURLConnection.h"
#import "NJIBasic.h"
#import "NJIUploadImageResponse.h"

@interface NJIUploadOperation ()

@property (nonatomic, weak)     id<NJIUploadDelegate>   delegate;
@property (nonatomic, strong)   NJIUpload*              upload;

@end

@implementation NJIUploadOperation

- (id)initWithUpload:(NJIUpload*)upload withDelegate:(id<NJIUploadDelegate>)delegate
{
    if (![upload isKindOfClass:[NJIUpload class]])
    {
        return nil;
    }
    
    if (upload.image == nil)
    {
        return nil;
    }
    
    self = [super init];
    
    if (self)
    {
        self.delegate = delegate;
        self.upload = upload;
    }
    
    return self;
}

- (void)main
{
    NJIUploadFileRequest *request = [[NJIUploadFileRequest alloc] initWithUpload:self.upload];
    
    //Check that request was created correctly
    if (!request)
    {
        [self failWithError:NJIResponseStatusFailedWithUnknownReason];
    }
    
    //Set the timeout of the upload if the delegate implements that method
    if ([self.delegate respondsToSelector:@selector(timeoutIntervalForUpload:)])
    {
        [request setTimeoutInterval:[self.delegate timeoutIntervalForUpload:self.upload]];
    }

    NSData* data = nil;
    NSHTTPURLResponse* response = nil;
    
    //Check that this thread wasn't cancelled
    if ([self isCancelled])
    {
        [self failWithError:NJIResponseStatusFailedWithUnknownReason];
        return;
    }

    NJIResponseStatus responseStatus = [NJIURLConnection sendSynchronousRequest:request returningData:&data returningResponse:&response];
    
    //Check that this thread wasn't cancelled
    if ([self isCancelled])
    {
        [self failWithError:NJIResponseStatusFailedWithUnknownReason];
        return;
    }
    
    if (responseStatus != NJIResponseStatusEverythingOkay)
    {
        [self failWithError:responseStatus];
        return;
    }

    NJIBasic* basic = [[NJIBasic alloc] initWithJSONData:data];
    
    if (!basic)
    {
        //If we could not initiate a basic object it means that there is something wrong in the response, probably the JSON
        [self failWithError:NJIResponseStatusUnableToParseJSON];
        return;
    }
    
    NJIUploadImageResponse* uploadImageResponse = [[NJIUploadImageResponse alloc] initWithDictionary:basic.data responseHTTPHeaders:response.allHeaderFields];
    
    if (!uploadImageResponse)
    {
        //Failed to parse JSON response
        [self failWithError:NJIResponseStatusUnableToParseJSON];
        return;
    }

    //Everything seems to be okay, inform delegate
    [self finishedWithResponse:uploadImageResponse];
}

- (void)failWithError:(NJIResponseStatus)status
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate failedToUploadImage:self.upload withError:status];
    }];
    
#ifdef NJITESTING
    //I don't know why the callback block is never executed, so if we're running tests let's just call the delegate in the current thread
    [self.delegate failedToUploadImage:self.upload withError:status];
#endif
}

- (void)finishedWithResponse:(NJIUploadImageResponse*)response
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.delegate finishedUploadingImage:self.upload withResult:response];
    }];
    
#ifdef NJITESTING
    //I don't know why the callback block is never executed, so if we're running tests let's just call the delegate in the current thread
    [self.delegate finishedUploadingImage:self.upload withResult:response];
#endif
}

@end
