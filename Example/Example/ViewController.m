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
@property (weak, nonatomic) IBOutlet UIView *preview;

@property (strong, nonatomic) AXLoadingView *v1;

@property (strong, nonatomic) AXLoadingView *v2;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.v1 = [[AXLoadingView alloc] initWithFrame:CGRectMake(100, 0, 150, 100) style:AXLoadingViewStyleLinear];
    self.v1.trackWidth = 4;
    [self.preview addSubview:self.v1];
    

    self.v2 = [[AXLoadingView alloc] initWithFrame:CGRectMake(100, 120, 32, 32) style:AXLoadingViewStyleCircular];
    self.v2.trackWidth = 2;
    [self.preview addSubview:self.v2];
    
    typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (weakSelf.v1.progress <= 1 && weakSelf.v1.progress >= 0) {
            weakSelf.v1.progress += 0.03;
            weakSelf.v2.progress += 0.03;
        }
    }];
    
    NSArray *arr = [UIFont familyNames];
    NSLog(@"%@", arr);
    
}

- (IBAction)btn:(UIButton *)sender {
    if (self.v1.progress >= 0) {
        self.v1.progress = -1;
        self.v2.progress = -1;
    } else {
        self.v1.progress = 0;
        self.v2.progress = 0;
    }
}


@end
