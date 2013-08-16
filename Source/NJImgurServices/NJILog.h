//
//  NJILog.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 7/21/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#ifdef NJIDEBUG
#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DLog(...)
#endif

#ifndef NJImgurServices_NJILog_h
#define NJImgurServices_NJILog_h

#endif
