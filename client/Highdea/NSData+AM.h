//
//  NSData+AM.h
//  AM
//
//  Created by Mason on 10/7/12.
//  Copyright (c) 2012 CasuaLlama. All rights reserved.
//

@interface NSData (AM)

- (BOOL) empty;
- (BOOL) unempty;
- (NSUInteger) count;
- (NSUInteger) size;

+ (NSData*) dataFromBase64String:(NSString *)aString;
- (NSString*) base64EncodedString;

- (NSString*) md5;

@end
