//
//  NJIFileManagerController.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/23/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIFileManagerController.h"

@implementation NJIFileManagerController

+ (NSString*)privateDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    libraryDirectory = [libraryDirectory stringByAppendingPathComponent:@"NJImgurServices Supporting Files"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:libraryDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error)
    {
        libraryDirectory = nil;
    }
    
    return libraryDirectory;
}

+ (NSString*)pathToArchiveObjectOfClass:(Class)theClass
{
    if (!theClass || NSStringFromClass(theClass) == nil)
    {
        return nil;
    }
    
    return [[NJIFileManagerController privateDirectoryPath] stringByAppendingPathComponent:NSStringFromClass(theClass)];
}

+ (BOOL)deleteFileAtPath:(NSString*)path
{
    NSError* error = nil;
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    if (error)
    {
        DLog(@"Failed to delete item at path: %@. %@", path, error);
    }
    
    return error == nil;
    
}

@end
