//
//  HomeViewController.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/20.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "HomeViewController.h"
#import "ZMVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"ZOOM会议模式";
}
- (IBAction)joinRoom:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    ZMVideoViewController *videoController = [ZMVideoViewController new];
    videoController.meetId = self.textField.text;
    [self presentViewController:videoController animated:YES completion:nil];
}
//授权相机
- (void)videoAuthAction
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
    }];
}

//授权麦克风
- (void)audioAuthAction
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"麦克风准许":@"麦克风不准许");
    }];
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
