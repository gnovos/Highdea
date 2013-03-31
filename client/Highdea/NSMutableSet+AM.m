//
//  NSMutableSet+AM.m
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

#import "NSMutableSet+AM.h"

@implementation NSMutableSet (AM)

- (BOOL) removeIfContained:(id)obj {
    @synchronized(self) {
        BOOL contained = [self containsObject:obj];
        if (contained) {
            [self removeObject:obj];
        }
        return contained;
    }
}


@end
