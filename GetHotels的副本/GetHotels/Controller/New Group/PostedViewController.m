//
//  PostedViewController.m
//  GetHotels
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PostedViewController.h"

@interface PostedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *moringTextField;
@property (weak, nonatomic) IBOutlet UITextField *bedTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *weekendsTextField;
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation PostedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
