//
//  BaseViewController.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/20.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)toOrientation:(UIInterfaceOrientation)orientation {
    [UIView beginAnimations:nil context:nil];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationUnknown] forKey:@"orientation"];
    // 旋转屏幕
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    [UIView setAnimationDelegate:self];
    //开始旋转
    [UIView commitAnimations];
    [self.view layoutIfNeeded];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
