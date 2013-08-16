//
//  NJIRequestParameter.h
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NJIRequestParameter : NSObject

@property (nonatomic, strong) NSString*     key;
@property (nonatomic, strong) NSString*     value;

- (id)initWithKey:(NSString*)key value:(NSString*)value;

/**
 Returns the string representation of the parameter in the form of key=value
 @return The string representation
 @discussion This method already escapes all characters that may screw an HTTP request
 @discussion If key or value is nil, stringRepresnetation returned will be nil
 */
- (NSString*)stringRepresentation;

/**
 Returns the string representation of the array provided as parameter
 @param parameters The Array containing at least one NJIRequestParameter
 @return The string representation
 @discussion This method will concatenate the string representation of the provided parameter objects using "&"
 @discussion If an empty array is provided, nil will be returned
 */
+ (NSString*)stringRepresentationForParameters:(NSArray*)parameters;

/**
 Returns an array containing the parameters from the provided URL.
 @param url The URL string.
 @return The array containing NJIRequestParameter objects
 @discussion If url provided does not contain any parameter, an empty array will be returned
 @discussion A sample parameter for this method is "http://example.com/#param1=value1&param2=value2" where http://example.com is the callbackURL.
 */
+ (NSArray*)parametersFromURLString:(NSString*)url;

/**
 Returns an array containing the parameters from the URL encoded string
 @param string The parameters from the URL
 @return The array containing NJIRequestParameter objects
 @discussion A sample parameter for this method is "param1=value1&param2=value2"
 */
+ (NSArray*)parametersFromURLParametersString:(NSString*)string;

/**
 Returns the NJIRequestParameter object initiated from the stringRepresentation
 @param stringRepresentation The string representation
 @return A newly initialized NJIRequestParameter object, or nil if unable to parse parameter.
 @discussion A sample parameter for this method would be "param1=value1"
 */
+ (NJIRequestParameter*)parameterWithStringRepresentation:(NSString*)stringRepresentation;

@end
