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

@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;//房间名文本框
@property (weak, nonatomic) IBOutlet UITextField *moringTextField;//是否含早
@property (weak, nonatomic) IBOutlet UITextField *bedTextField;//床型
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;//面积
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;//价格
@property (weak, nonatomic) IBOutlet UITextField *weekendsTextField;//周末节假日
@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;//图片
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSMutableArray *pickerArray;
@property (strong, nonatomic) NSMutableArray *hotelNamePickerArr;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
- (IBAction)cancelAction:(UIBarButtonItem *)sender;

- (IBAction)yesAction:(UIBarButtonItem *)sender;

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation PostedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerArray = [NSMutableArray new];
    [_pickerView selectRow:1 inComponent:0 animated:YES];
    
    [_pickerView reloadComponent:0];
    _hotelNamePickerArr = [NSMutableArray new];
    [self navigationConfiguration];
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

    if ([_selectBtn.titleLabel.text isEqualToString:@"请选择酒店"]) {
        [Utilities popUpAlertViewWithMsg:@"请选择酒店" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if([_roomNameTextField.text  isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写房间名" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if ([_areaTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请选择房间面积" andTitle:@"提示" onView:self onCompletion:^{}];
    }else if([_priceTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:@"提示" onView:self
            onCompletion:^{}];
    }else if(_priceTextField.text.length >= 5){
        [Utilities popUpAlertViewWithMsg:@"房间价格不合理，请重新填写价格" andTitle:@"提示" onView:self onCompletion:^{}];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定发布" preferredStyle:UIAlertControllerStyleAlert];
        //创建提示框的确认按钮
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self issueRequest];

            //返回上个页面
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        //创建提示框的取消按钮
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        //将按钮添加到提示框中 （多个按钮从左到右，从上到下，如果按钮的风格是UIAlertActionStyleCancel 是中是最左或者最下）
        [alert addAction:actionA];
        [alert addAction:actionB];
        
        //将提示框显示出来
        [self presentViewController:alert animated:YES completion:nil];
        
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
    NSString *roomName = _roomNameTextField.text;//房间名称
    NSString *moring = _moringTextField.text;//含早
    NSString *type = _bedTextField.text;//床型
    NSString *area = _areaTextField.text;//面积
    NSString *roomtype = [NSString stringWithFormat:@"%@,%@,%@,%@",roomName,moring,type,area];
    
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSString *title= _hotelNamePickerArr[row];
    [_selectBtn setTitle:title forState:UIControlStateNormal];
    _imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1505461689&di=9c9704fab9db8eccb77e1e1360fdbef4&imgtype=jpg&er=1&src=http%3A%2F%2Fimg3.redocn.com%2Ftupian%2F20150312%2Fhaixinghezhenzhubeikeshiliangbeijing_3937174.jpg";
    
    NSDictionary *para =@{@"business_id":@1,@"hotel_name":title, @"hotel_type":roomtype, @"room_imgs":_imgUrl,@"price":_priceTextField.text};

    [RequestAPI requestURL:@"/addHotel" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        if ([responseObject[@"result"]integerValue] == 1){
            NSLog(@"issue:%@",responseObject[@"result"]);
        }
            NSLog(@"title = %@", title);
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld", (long)statusCode);
    }];
}

//获取酒店名称列表
- (void)searchRequset{
    [RequestAPI requestURL:@"/searchHotelName" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        
        if ([responseObject[@"result"]integerValue] == 1) {
            _pickerArray = responseObject[@"content"];
            for (NSDictionary *dict in _pickerArray) {
                NSString *str = dict[@"hotel_name"];
                [_hotelNamePickerArr addObject:str];
                NSLog(@"_hotelNamePickerArr = %@", _hotelNamePickerArr);
            }
            [_pickerView reloadAllComponents];
        }else{
            [Utilities popUpAlertViewWithMsg:@"网络错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"%ld",(long)statusCode);
    }];
}

- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self searchRequset];
}

#pragma mark - PickerView
//多少列(组)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _hotelNamePickerArr.count;
}

//设置每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _hotelNamePickerArr[row];

}

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _maskView.hidden = YES;
}

- (IBAction)yesAction:(UIBarButtonItem *)sender {
    //拿到当前选中某一列的行号
    NSInteger row = [_pickerView selectedRowInComponent:0];
    //通过上述行号到数组中拿数据
    NSString *title = [NSString stringWithFormat:@"%@",_hotelNamePickerArr[row]];
    //将拿到的数据显示在按钮上面
    [_selectBtn setTitle:title forState:UIControlStateNormal];
    
    _maskView.hidden = YES;
    
}

- (IBAction)selectAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self searchRequset];
    _maskView.hidden = NO;
    [self initializeData];
    [self.view endEditing:YES];
    
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

@end
