//
//  NSMutableDictionary+AM.m
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

#import "NSMutableDictionary+AM.h"

@implementation NSMutableDictionary (AM)

- (id) yankObjectForKey:(id)key {
    @synchronized(self) {
        id obj = [self objectForKey:key];
        [self removeObjectForKey:key];
        return obj;
    }
}


@end
