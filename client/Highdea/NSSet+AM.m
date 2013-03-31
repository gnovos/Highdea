//
//  NSSet+AM.m
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

#import "NSSet+AM.h"

@implementation NSSet (AM)

- (BOOL) empty { return self.count == 0; }
- (BOOL) unempty { return !self.empty; }
- (NSUInteger) length { return self.count; }
- (NSUInteger) size { return self.count; }

@end
