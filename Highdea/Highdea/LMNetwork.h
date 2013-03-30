//
//  LMNetwork.h
//  Highdea
//
//  Created by Mason on 3/26/13.
//  Copyright (c) 2013 LoMason. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^LMResponse)(MKNetworkOperation* response, NSString* body, NSError* error);

@interface LMNetwork : MKNetworkEngine

+ (id) instance;

- (MKNetworkOperation*) get:(NSString*)api onComplete:(LMResponse)completion;

@end
