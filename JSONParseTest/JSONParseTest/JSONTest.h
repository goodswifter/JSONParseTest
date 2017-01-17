//
//  JSONTest.h
//  Test01
//
//  Created by zhongad on 2017/1/16.
//  Copyright © 2017年 zhongad. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RunWithCount(count, description, expr) \
do { \
CFAbsoluteTime start = CFAbsoluteTimeGetCurrent(); \
for(NSInteger i = 0; i < count; i++) { \
expr; \
} \
\
CFTimeInterval took = CFAbsoluteTimeGetCurrent() - start; \
NSLog(@"%@ %0.3f", description, took); \
\
} while (0)

@interface JSONTest : NSObject

- (NSData *)loadDataFromResource:(NSString *)resource;

- (NSString *)loadStringDataFromResource:(NSString *)resource;

- (void)runWithResourceName:(NSString *)resourceName count:(NSInteger)count;

@end
