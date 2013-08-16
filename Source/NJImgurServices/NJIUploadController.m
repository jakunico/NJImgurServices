//
//  NJIUploadController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIUploadController.h"
#import "NJIConstants.h"
#import "NJIUploadOperation.h"
#import "NJIController.h"

@interface NJIUploadController ()

@property (nonatomic, strong) NSOperationQueue*     uploadQueue;
@property (nonatomic) UIBackgroundTaskIdentifier    backgroundTask;

@end

@implementation NJIUploadController

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.uploadQueue = [[NSOperationQueue alloc] init];
        self.uploadQueue.maxConcurrentOperationCount = NJI_MAXIMUM_NUMBER_OF_OPERATIONS;
        
        [self.uploadQueue addObserver:self forKeyPath:@"operationCount" options:NSKeyValueObservingOptionNew context:nil];
        
        [[NJIController instance] addObserverToLogoutNotification:self selector:@selector(logoutNotification)];
    }
    
    return self;
}

#pragma mark - Public Methods -
#pragma mark -

+ (NJIUploadController*)instance
{
    static NJIUploadController* instance;
    
    if (!instance)
    {
        instance = [[NJIUploadController alloc] init];
    }
    
    return instance;
}

- (BOOL)addUpload:(NJIUpload*)upload withDelegate:(id<NJIUploadDelegate>)delegate
{
    if (upload == nil) {
        return NO;
    }
    
    NJIUploadOperation* operation = [[NJIUploadOperation alloc] initWithUpload:upload withDelegate:delegate];
    
    if (operation == nil)
    {
        return NO;
    }
    
    [self.uploadQueue addOperation:operation];
    
    return YES;
}

- (BOOL)addUploads:(NSArray*)uploadArray withDelegate:(id<NJIUploadDelegate>)delegate
{
    BOOL allUploadsCorrectlyAdded = YES;
    
    for (NJIUpload* upload in uploadArray) {
        if (![self addUpload:upload withDelegate:delegate])
        {
            allUploadsCorrectlyAdded = NO;
        }
    }
    
    return allUploadsCorrectlyAdded;
}

- (void)cancelAllUploads
{
    [self.uploadQueue cancelAllOperations];
}

- (void)beginBackgroundTask
{
    if ([[UIDevice currentDevice] isMultitaskingSupported])
    {
        self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self cancelAllUploads];
            self.backgroundTask = UIBackgroundTaskInvalid;
        }];
    }
}

#pragma mark - KVO Methods -
#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"operationCount"])
    {
        [self uploadQueueChanged];
    }
}


#pragma mark - Private Methods -
#pragma mark -

- (void)logoutNotification
{
    [self cancelAllUploads];
}

/**
 This method is called when the upload queue's operation count changed
 */
- (void)uploadQueueChanged
{
    DLog(@"Remaining uploads: %i", [self.uploadQueue operationCount]);
    
    if ([self.uploadQueue operationCount] == 0)
    {
        //End the background task (if there is any)
        if (self.backgroundTask && self.backgroundTask != UIBackgroundTaskInvalid)
        {
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];
            self.backgroundTask = UIBackgroundTaskInvalid;
        }
    }
}

@end
