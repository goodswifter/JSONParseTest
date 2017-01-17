//
//  JSONTest.m
//  Test01
//
//  Created by zhongad on 2017/1/16.
//  Copyright © 2017年 zhongad. All rights reserved.
//

#import "JSONTest.h"
#import "CJSONDeserializer.h"
#import "JSONKit.h"
#import "NXJsonParser.h"
#import <SBJson5/SBJson5.h>
#import "YAJLParser.h"

@implementation JSONTest

- (NSData *)loadDataFromResource:(NSString *)resource {
    NSParameterAssert(resource);
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[resource stringByDeletingPathExtension] ofType:[resource pathExtension]];
    if (!resourcePath) [NSException raise:NSInvalidArgumentException format:@"Resource not found: %@", resource];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:resourcePath options:0 error:&error];
    if (error) [NSException raise:NSInvalidArgumentException format:@"Error loading resource at path (%@): %@", resourcePath, error];
    return data;
}

- (NSString *)loadStringDataFromResource:(NSString *)resource {
    return [[NSString alloc] initWithData:[self loadDataFromResource:resource] encoding:NSUTF8StringEncoding];
}

- (void)SBJSONTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    RunWithCount(count, ([NSString stringWithFormat:@"SBJSON-%@", resourceName]), {
        SBJson5ValueBlock block = ^(id v, BOOL *stop) {
//            NSLog(@"Found: %@", [v description]);
        };
        
        SBJson5ErrorBlock eh = ^(NSError* err) {
//            NSLog(@"OOPS: %@", err);
            exit(1);
        };
        SBJson5Parser *parser = [SBJson5Parser unwrapRootArrayParserWithBlock:block
                                                                 errorHandler:eh];
        
        [parser parse:JSONData]; // returns SBJson5ParserWaitingForData
    });
}

- (void)touchJSONTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    NSError *error = nil;
    RunWithCount(count, ([NSString stringWithFormat:@"TouchJSON-%@", resourceName]), { [[CJSONDeserializer deserializer] deserialize:JSONData error:&error]; });
    NSAssert1(error == nil, @"Errored: %@", error);
}

- (void)JSONKitTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    RunWithCount(count, ([NSString stringWithFormat:@"JSONKit-%@", resourceName]), {
        [JSONData objectFromJSONData];
    });
}

- (void)nextiveJsonTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    RunWithCount(count, ([NSString stringWithFormat:@"NextiveJson-%@", resourceName]), {
        NXJsonParser *parser = [[NXJsonParser alloc] initWithData:JSONData];
        [parser parse:nil ignoreNulls:NO];
    });
}

- (void)NSJSONSerializationTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    NSError *error = nil;
    RunWithCount(count, ([NSString stringWithFormat:@"NSJSONSerialization-%@", resourceName]), {
        [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    });
    NSAssert1(error == nil, @"Errored: %@", error);
}

- (void)YAJLTest:(NSString *)resourceName count:(NSInteger)count {
    NSData *JSONData = [self loadDataFromResource:resourceName];
    RunWithCount(count, ([NSString stringWithFormat:@"YAJL-%@", resourceName]), {
        YAJLParser *parser = [[YAJLParser alloc] initWithParserOptions:YAJLParserOptionsNone];
        [parser parse:JSONData];
    });
}

- (void)runWithResourceName:(NSString *)resourceName count:(NSInteger)count {
    if (NSClassFromString(@"NSJSONSerialization")) {
        [self NSJSONSerializationTest:resourceName count:count];
    }
    [self YAJLTest:resourceName count:count];
    [self nextiveJsonTest:resourceName count:count];
    [self JSONKitTest:resourceName count:count];
    [self touchJSONTest:resourceName count:count];
    [self SBJSONTest:resourceName count:count];
}

@end
