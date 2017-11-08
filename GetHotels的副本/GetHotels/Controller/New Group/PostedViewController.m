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
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelItem;

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

//设置导航栏的方法
- (void)navigationConfiguration{
    //设置导航栏标题颜色
    //创建一个属性字典
    NSDictionary *titleTextOption = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //将上述的数字字典配置给导航栏的标题
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextOption];
    //更改导航栏的标题
    self.navigationItem.title = NSLocalizedString(@"酒店发布", nil);
    //设置导航栏颜色（风格颜色：导航栏整体的背景色和状态栏整体的背景色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(14, 124, 246);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //    [UIColor colorWithRed:41.f/255.f green:124.f/255.f blue:246.f/255.f alpha:1];
    //配置导航栏的毛玻璃效果 YES表示有  NO表示没有
    [self.navigationController.navigationBar setTranslucent:YES];
    //设置导航栏是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //配置导航栏上的item的风格颜色（如果是文字则文字变成白色，如果是图片则图片的透明部分变成白色）
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //自定义返回按钮
    //self.navigationController.navigationItem.leftBarButtonItem = ;
}

#pragma mark - 选择酒店按钮样式
- (void)btnStyle{
    [_selectBtn.layer setBorderColor:[UIColor colorWithRed:0.19 green:0.57 blue:0.95 alpha:1].CGColor];//边框颜色
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
