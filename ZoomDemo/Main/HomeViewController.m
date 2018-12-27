//
//  HomeViewController.m
//  ZoomDemo
//
//  Created by zjq on 2018/12/20.
//  Copyright © 2018 zjq. All rights reserved.
//

#import "HomeViewController.h"
#import "ZMVideoViewController.h"

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

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
