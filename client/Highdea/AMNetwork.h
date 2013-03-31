//
//  AMNetwork.h
//  Highdea
//
//  Created by Mason on 3/26/13.
//  Copyright (c) 2013 LoMason. All rights reserved.
//

#import "MKNetworkEngine.h"

typedef void (^AMResponse)(MKNetworkOperation* response, NSString* body, NSError* error);

@interface AMNetwork : MKNetworkEngine

+ (id) instance;

- (MKNetworkOperation*) get:(NSString*)api onComplete:(AMResponse)completion;

@end
