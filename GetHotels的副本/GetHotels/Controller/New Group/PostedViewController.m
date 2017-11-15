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
@property (strong, nonatomic) NSMutableArray *hotelNamePickerArr;
@property (strong, nonatomic) NSString *imgUrl;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;

- (IBAction)yesAction:(UIBarButtonItem *)sender;

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation PostedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _hotelNamePickerArr = [NSMutableArray new];
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
        [Utilities popUpAlertViewWithMsg:@"请选择房间面积" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if(_priceTextField.text.length >= 5){
        [Utilities popUpAlertViewWithMsg:@"房间价格不合理，请重新填写价格" andTitle:@"提示" onView:self onCompletion:^{}];
    }else{

        //返回上个页面
        [self.navigationController popViewControllerAnimated:YES];
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
//发布 的网络请求
- (void)issueRequest{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSString *title= _hotelNamePickerArr[row];
    [_selectBtn setTitle:title forState:UIControlStateNormal];
    _imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505461689&di=9c9704fab9db8eccb77e1e1360fdbef4&imgtype=jpg&er=1&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20150312%2Fhaixinghezhenzhubeikeshiliangbeijing_3937174.jpg";
    NSDictionary *para =@{@"business_id":@2,@"hotel_name":title ,@"hotel_type":_areaTextField.text,@"room_imgs":_imgUrl,@"price":_priceTextField.text};
    
    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        if ([responseObject[@"result"]integerValue] == 1){
            NSLog(@"issue:%@",responseObject[@"result"]);
        }
        
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld", (long)statusCode);
    }];
    
}


#pragma mark - Hiddenkeyboard
//Return键是否能被点击 返回YES表示能点，返回NO表示不能被点
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //收起键盘
    //[textField resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}

//点击键盘以外的部分收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
