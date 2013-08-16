//
//  NJIConstants.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

/**
 Determines the number of uploads that can occurr at the same time. For example, if set to '2', when uploading multiple images at the same time, a maximum of two images can be uploading at the same time
 */
#define NJI_MAXIMUM_NUMBER_OF_OPERATIONS        1

//URL CONSTANTS

#define NJI_API_BASE_URL                @"https://api.imgur.com"
#define NJI_API_VERSION                 @"3"
#define NJI_API_UPLOAD_RESOURCE         @"image"
#define NJI_API_CREDITS_RESOURCE        @"credits"
#define NJI_API_AUTHORIZE_RESOURCE      @"oauth2/authorize"
#define NJI_API_REFRESH_TOKEN_RESOURCE  @"oauth2/token"

/**
 Different types of request authroization
 @see https://api.imgur.com/oauth2#authorization
 */
#define NJI_API_AUTHORIZATION_RESPONSE_TYPE_CODE        @"code"
#define NJI_API_AUTHORIZATION_RESPONSE_TYPE_TOKEN       @"token"
#define NJI_API_AUTHORIZATION_RESPONSE_TYPE_PIN         @"pin"

#define NJI_HTTP_METHOD_POST        @"POST"
#define NJI_HTTP_METHOD_GET         @"GET"
#define NJI_HTTP_METHOD_DELETE      @"DELETE"
#define NJI_HTTP_METHOD_PUT         @"PUT"
#define NJI_HTTP_METHOD_PATCH       @"PATCH"