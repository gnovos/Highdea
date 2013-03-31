//
//  NSMutableArray+AM.m
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

#import "NSMutableArray+AM.h"
#import "NSArray+AM.h"

@implementation NSMutableArray (AM)

- (id) yank:(NSUInteger)index {
    @synchronized(self) {
        id obj = [self objectAtIndex:index];
        [self removeObjectAtIndex:index];
        return obj;
    }
}

- (id) pop {
    @synchronized(self) {
        id last = [self lastObject];
        [self removeLastObject];
        return last;
    }
}

- (id) shift {
    @synchronized(self) {
        if (self.empty) { return nil; }
        
        id first = [self objectAtIndex:0];
        [self removeObjectAtIndex:0];
        return first;
    }
}



@end
