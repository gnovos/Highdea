//
//  AMNetwork.m
//  Highdea
//
//  Created by Mason on 3/26/13.
//  Copyright (c) 2013 LoMason. All rights reserved.
//

#import "AMNetwork.h"

@implementation AMNetwork

AM_INIT_SINGELTON

- (id) init {
    if (self = [super initWithHostName:@"highdea.heroku.com"
                               apiPath:@"/api/0/"
                    customHeaderFields:@{
                        @"x-client-identifier" : @"iOS"
                    }
                ]
        ) {
    }
    return self;
}

- (MKNetworkOperation*) get:(NSString*)api onComplete:(AMResponse)completion {
    MKNetworkOperation* op = [self operationWithPath:api params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation* response) {
        completion(response, [response responseString], nil);
    } errorHandler:^(MKNetworkOperation* response, NSError* error) {
        completion(response, [response responseString], error);
    }];
    
    
    [self enqueueOperation:op];
    
    return op;
}

@end
