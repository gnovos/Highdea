//
//  LMNetwork.m
//  Highdea
//
//  Created by Mason on 3/26/13.
//  Copyright (c) 2013 LoMason. All rights reserved.
//

#import "LMNetwork.h"

@implementation LMNetwork

LM_INIT_SINGELTON

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

- (MKNetworkOperation*) get:(NSString*)api onComplete:(LMResponse)completion {
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
