//
//  NJIRequestParameter.m
//  NJImgurServices
//
//  Created by Nicolas Jakubowski on 6/16/13.
//  Copyright (c) 2013 Nicolas Jakubowski. All rights reserved.
//

#import "NJIRequestParameter.h"
#import "NSString+URLEncoding.h"
#import "NJIController.h"

@implementation NJIRequestParameter

- (id)initWithKey:(NSString*)key value:(NSString*)value
{
    self = [super init];
    
    if (self)
    {
        self.key = key;
        self.value = value;
    }
    
    return self;
}

- (NSString*)stringRepresentation
{
    if (!self.value || !self.key)
    {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%@=%@", [self.key urlEncode], [self.value urlEncode]];
}

+ (NSString*)stringRepresentationForParameters:(NSArray*)parameters
{
    if ([parameters count] == 0)
    {
        return nil;
    }
    
    NSString* resultString = @"";
    
    for (int i=0; i < [parameters count]; i++)
    {   
        NSString* currentParameterStringRepresentation = [parameters[i] stringRepresentation];
        
        if (currentParameterStringRepresentation != nil)
        {
            resultString = [resultString stringByAppendingString:currentParameterStringRepresentation];
            
            //Add "&" if there will be another parameter to add
            if (i != [parameters count] - 1)
            {
                resultString = [resultString stringByAppendingString:@"&"];
            }
        }
    }

    return resultString;
}

+ (NSArray*)parametersFromURLString:(NSString*)url
{
    //We'll keep the encoded parameters from the absolut url given as parameter
    NSRange rangeOfNumeral = [url rangeOfString:@"#"];
    
    if (rangeOfNumeral.location == NSNotFound)
    {
        //We couldn't find a "#" in the URL so it's not sending the expected response
        return nil;
    }
    
    //TODO: Does parameterString work from NSURL object?
    
    //Now, remove the callbackURL so just the parameters remain
    NSString* parametersString = [url substringFromIndex:rangeOfNumeral.location+1];
    
    return [NJIRequestParameter parametersFromURLParametersString:parametersString];
}

+ (NSArray*)parametersFromURLParametersString:(NSString*)string
{
    NSMutableArray* resultArray = [NSMutableArray array];
    
    //First, separate the array by "&"
    NSArray* parametersArray = [string componentsSeparatedByString:@"&"];
    
    for (NSString* stringRepresentation in parametersArray)
    {
        NJIRequestParameter* requestParameter = [NJIRequestParameter parameterWithStringRepresentation:stringRepresentation];
        
        if (requestParameter)
        {
            [resultArray addObject:requestParameter];
        }
    }
    
    return resultArray;
}

+ (NJIRequestParameter*)parameterWithStringRepresentation:(NSString*)stringRepresentation
{
    NSArray* components = [stringRepresentation componentsSeparatedByString:@"="];
    
    if ([components count] != 2)
    {
        return nil;
    }
    
    return [[NJIRequestParameter alloc] initWithKey:components[0] value:components[1]];
}

@end
