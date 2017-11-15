//
//  PostedViewController.m
//  GetHotels
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "PostedViewController.h"
#import "Utilities.h"

@interface PostedViewController ()<UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>{
    UIImagePickerController *imagePickerController;
}
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
@property (strong, nonatomic) NSArray *array;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;

- (IBAction)yesAction:(UIBarButtonItem *)sender;

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation PostedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化数组并添加元素
    [self navigationConfiguration];
    _array = @[@"周一", @"周二", @"周三", @"周四", @"周五"];
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
    //为导航条左上角创建一个按钮
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backAction)];
//    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(Issue)];
    self.navigationItem.rightBarButtonItem = right;
    //自定义返回按钮
    //self.navigationController.navigationItem.leftBarButtonItem = ;
}

- (void)Issue{

    if([_priceTextField.text  isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if ([_areaTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请选择房间类型" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if(_priceTextField.text.length >= 5){
        [Utilities popUpAlertViewWithMsg:@"房间价格不合理，请重新填写价格" andTitle:@"提示" onView:self onCompletion:^{}];
    }else{
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Request
- (void)issueRequest{
    
}

#pragma mark - PickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 5;
}


- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _pickerView.hidden = YES;
    _toolBar.hidden = YES;
}

- (IBAction)yesAction:(UIBarButtonItem *)sender {
    _pickerView.hidden = YES;
    _toolBar.hidden = YES;
}

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event {
    _pickerView.hidden = NO;
    _toolBar.hidden = NO;
}
@end
