//
//  NSDictionary+AMUtil.h
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

@interface NSDictionary (AM)

- (BOOL) empty;
- (BOOL) unempty;
- (NSUInteger) size;
- (NSUInteger) length;

- (BOOL) hasKey:(id)key;
- (BOOL) containsKey:(id)key;

@end
