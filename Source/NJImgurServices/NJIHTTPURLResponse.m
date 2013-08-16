//
//  NJIHTTPURLResponse.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIHTTPURLResponse.h"

@implementation NJIHTTPURLResponse

- (NJIResponseStatus)responseStatus
{
    if (self.statusCode == NJIResponseStatusAuthenticationRequired) {
        return NJIResponseStatusAuthenticationRequired;
    }else if (self.statusCode == NJIResponseStatusBadParameters){
        return NJIResponseStatusBadParameters;
    }else if (self.statusCode == NJIResponseStatusEverythingOkay){
        return NJIResponseStatusEverythingOkay;
    }else if (self.statusCode == NJIResponseStatusForbidden){
        return NJIResponseStatusForbidden;
    }else if (self.statusCode == NJIResponseStatusInternalServerError){
        return NJIResponseStatusInternalServerError;
    }else if (self.statusCode == NJIResponseStatusMissingResource){
        return NJIResponseStatusMissingResource;
    }else if (self.statusCode == NJIResponseStatusReachedRateLimit){
        return NJIResponseStatusReachedRateLimit;
    }else{
        return NJIResponseStatusFailedWithUnknownReason;
    }
}

- (BOOL)isSuccess
{
    return [self responseStatus] == NJIResponseStatusEverythingOkay;
}

@end
