//
//  NJIFileManagerController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/23/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIFileManagerController : NSObject

+ (NSString*)privateDirectoryPath;

+ (NSString*)pathToArchiveObjectOfClass:(Class)theClass;

+ (BOOL)deleteFileAtPath:(NSString*)path;

@end
