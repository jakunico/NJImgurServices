//
//  NJIUploadImageResponse.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/22/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIBaseResponse.h"
#import "NJICredits.h"

@interface NJIUploadImageResponse : NJIBaseResponse

@property (nonatomic, readonly) NSString*       imageId;
@property (nonatomic, readonly) NSString*       deleteHash;
@property (nonatomic, readonly) NSString*       link;

@end
