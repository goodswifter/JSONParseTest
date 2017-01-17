//
//  ViewController.m
//  JSONParseTest
//
//  Created by zhongad on 2017/1/17.
//  Copyright © 2017年 zhongad. All rights reserved.
//

#import "ViewController.h"
#import "JSONTest.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JSONTest *test = [[JSONTest alloc] init];
    
    NSInteger count = 100;
    
    [test runWithResourceName:@"twitter_public.json" count:count];
    NSLog(@"\n\n\n");
    [test runWithResourceName:@"lastfm.json" count:count];
    NSLog(@"\n\n\n");
    [test runWithResourceName:@"delicious_popular.json" count:count];
    NSLog(@"\n\n\n");
    [test runWithResourceName:@"yelp.json" count:count];
    NSLog(@"\n\n\n");
}

@end
