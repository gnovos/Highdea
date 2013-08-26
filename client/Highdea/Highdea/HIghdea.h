//
//  HIighdea.h
//  Highdea
//
//  Created by Mason on 8/25/13.
//  Copyright (c) 2013 Tych. All rights reserved.
//

@interface HIghdea : NSObject

@property (nonatomic, strong) NSString* device;
@property (nonatomic, strong) NSString* idea;

+ (void) highdeas:(void(^)(NSArray* ideas))completion;
+ (void) create:(NSString*)idea withCompletion:(void(^)(NSArray* ideas))completion ;

@end
