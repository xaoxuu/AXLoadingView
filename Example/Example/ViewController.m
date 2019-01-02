//
//  ViewController.m
//  Example
//
//  Created by xaoxuu on 2019/1/2.
//  Copyright © 2019 xaoxuu. All rights reserved.
//

#import "ViewController.h"
#import <AXLoadingView/AXLoadingView.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    AXLoadingView *v = [[AXLoadingView alloc] initWithFrame:CGRectMake(120, 120, 100, 100) style:AXLoadingViewStyleCircular];
    v.trackWidth = 10;
    [self.view addSubview:v];
    

    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        v.progress = 0;
//    });
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        v.progress = 0.5;
//    });
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        v.progress = 1;
//    });
    
}


@end
