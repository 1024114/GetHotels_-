//
//  QuoteViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "QuoteViewController.h"

@interface QuoteViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL tags;
}
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;//价格
@property (weak, nonatomic) IBOutlet UIButton *startBtn;//出发地
@property (weak, nonatomic) IBOutlet UIButton *endBtn;//目的地
@property (weak, nonatomic) IBOutlet UITextField *airlinesTextField;//航空公司
@property (weak, nonatomic) IBOutlet UITextField *flightTextField;//航班
@property (weak, nonatomic) IBOutlet UITextField *spaceTextField;//舱位
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;//行李重量
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *departuretimeBtn;//起飞时间
@property (weak, nonatomic) IBOutlet UIButton *arrivaltime;//到达时间
- (IBAction)cancelAction:(UIBarButtonItem *)sender;//toolBar取消按钮
- (IBAction)yesAction:(UIBarButtonItem *)sender;//toolBar确认按钮
- (IBAction)departuretime:(UIButton *)sender forEvent:(UIEvent *)event;//起飞时间按钮
- (IBAction)arrivaltime:(UIButton *)sender forEvent:(UIEvent *)event;//到达时间按钮
- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event;//确认按钮
- (IBAction)endAction:(UIButton *)sender forEvent:(UIEvent *)event;
- (IBAction)startAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)NSTimeInterval startTime;
@property(nonatomic)NSTimeInterval arrTime;
@property(nonatomic)NSTimeInterval tempTime;
@property(strong,nonatomic)NSMutableArray *selectOfferArr;

@end

@implementation QuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInitialize{
    _startTime = [NSDate.date timeIntervalSince1970];
    _arrTime = [NSDate.dateTomorrow timeIntervalSince1970];
}

#pragma mark -request
-(void)offerRequest{
    double price=[_priceTextField.text doubleValue];//价格
    NSInteger weight=[_weightTextField.text integerValue];//重量
    NSString *airlines=_airlinesTextField.text;//航空公司
    NSString *intimestr=_departuretimeBtn.titleLabel.text;//
    NSString *aviationcabin=_spaceTextField.text;//舱位
    NSString *outtimestr=_arrivaltime.titleLabel.text;//到达时间
    NSString *departurestr=_startBtn.titleLabel.text;//出发地
    NSString *destinationstr=_endBtn.titleLabel.text;//目的地
    NSString *flightNostr=_flightTextField.text;//航班
    
    NSDictionary *para=@{@"business_id":@2,@"aviation_demand_id":[[StorageMgr singletonStorageMgr]objectForKey:@"id"],@"final_price":@(price),@"weight":@(weight),@"aviation_company":airlines,@"aviation_cabin":aviationcabin,@"in_time_str":intimestr,@"out_time_str":outtimestr,@"departure":departurestr,@"destination":destinationstr,@"flight_no":flightNostr};
}

#pragma mark - TableView

//每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.dateLabel.text = @"123";
    return cell;
}

//细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}

//选中行时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消当前选中行的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

- (IBAction)yesAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

- (IBAction)departuretime:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
    tags = YES;
}

- (IBAction)arrivaltime:(UIButton *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden = NO;
    _pickerView.hidden = NO;
    tags = YES;
}

- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
- (IBAction)endAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"offerToCity" sender:nil];
}

- (IBAction)startAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"offerToCity" sender:nil];
}
@end
