//
//  NJIRequestError.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

/**
 Possible results for performing a request
 @see http://api.imgur.com/errorhandling
 */
typedef enum {
    NJIResponseStatusEverythingOkay = 200,
    NJIResponseStatusBadParameters = 400,
    NJIResponseStatusAuthenticationRequired = 401,
    NJIResponseStatusForbidden = 403,
    NJIResponseStatusMissingResource = 404,
    NJIResponseStatusReachedRateLimit = 429,
    NJIResponseStatusInternalServerError = 500,
    NJIResponseStatusFailedWithUnknownReason = 0, //We don't know the reason why the request failed, maybe try again later?
    NJIResponseStatusRequestTimedOut = 1, //Upload timedout, probably because of slow connection
    NJIResponseStatusMissingInternetConnection = 2, //Device doesn't have internet connection, ask the user to check it
    NJIResponseStatusUnableToParseJSON = 3 //There was a problem when parsing the response of the server, this is very unusual to happen
} NJIResponseStatus;