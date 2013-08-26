//
//  HIighdea.m
//  Highdea
//
//  Created by Mason on 8/25/13.
//  Copyright (c) 2013 Tych. All rights reserved.
//

#define HI_SERVER @"http://tych.herokuapp.com"
#define xHI_SERVER @"http://localhost:3000"

#import "HIghdea.h"

@implementation HIghdea

+ (void) highdeas:(void(^)(NSArray* ideas))completion {
    // Set up Article and Error Response Descriptors
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[HIghdea class]];
    [mapping addAttributeMappingsFromArray:@[@"device", @"idea"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *highdeaDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                           method:RKRequestMethodAny
                                                                                      pathPattern:@"/highdeas"
                                                                                          keyPath:nil
                                                                                      statusCodes:statusCodes];
    
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:nil toKeyPath:@"message"]];
    NSIndexSet *errorStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    // Any response in the 4xx status code range with an "errors" key path uses this mapping
    RKResponseDescriptor *errorDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping
                                                                                         method:RKRequestMethodAny
                                                                                    pathPattern:nil
                                                                                        keyPath:@"errors"
                                                                                    statusCodes:errorStatusCodes];
    
    // Add our descriptors to the manager
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:HI_SERVER]];
    [manager addResponseDescriptorsFromArray:@[ highdeaDescriptor, errorDescriptor ]];
    
    [manager getObjectsAtPath:@"/highdeas"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                          completion([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@\n%@", operation, error);
    }];
}

+ (void) create:(NSString*)idea withCompletion:(void(^)(NSArray* ideas))completion  {
    
    RKObjectMapping *responseMapping = [RKObjectMapping mappingForClass:[HIghdea class]];
    [responseMapping addAttributeMappingsFromArray:@[@"device", @"idea"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                                                            method:RKRequestMethodAny
                                                                                       pathPattern:@"/highdeas"
                                                                                           keyPath:@""
                                                                                       statusCodes:statusCodes];
    

    
    RKObjectMapping *requestMapping = [RKObjectMapping requestMapping]; // objectClass == NSMutableDictionary
    [requestMapping addAttributeMappingsFromArray:@[@"device", @"idea"]];
    
    // For any object of class Article, serialize into an NSMutableDictionary using the given mapping and nest
    // under the 'article' key path
    RKRequestDescriptor *requestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:requestMapping
                                                                                   objectClass:[HIghdea class]
                                                                                   rootKeyPath:@"highdea"
                                                                                        method:RKRequestMethodAny];
    
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:HI_SERVER]];
    
    [manager addRequestDescriptor:requestDescriptor];
    [manager addResponseDescriptor:responseDescriptor];
    
    HIghdea* highdea = [[HIghdea alloc] init];
    highdea.device = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    highdea.idea = idea;
    
    // POST to create
    [manager postObject:highdea path:@"/highdeas" parameters:nil
                success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                    completion([mappingResult array]);
                } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                    NSLog(@"\n\nFAIL\n%@\n%@", operation, error);
                }];
    
}


@end
