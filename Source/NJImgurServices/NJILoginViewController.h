//
//  NJILoginViewController.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/23/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIBaseViewController.h"
#import "NJILoginDelegate.h"

@interface NJILoginViewController : NJIBaseViewController

@property (nonatomic, readonly) id<NJILoginDelegate>    delegate;

- (id)initWithDelegate:(id<NJILoginDelegate>)delegate;

@end
