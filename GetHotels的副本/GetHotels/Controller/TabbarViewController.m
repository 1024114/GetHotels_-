//
//  TabbarViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/11/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "TabbarViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *nc = [Utilities getStoryboardInstance:@"Air" byIdentity:@"air"];
    nc.tabBarItem.image = [[UIImage imageNamed:@"aviation"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nc.tabBarItem.title = @"jkhkjhkj";
    [self addChildViewController:nc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
