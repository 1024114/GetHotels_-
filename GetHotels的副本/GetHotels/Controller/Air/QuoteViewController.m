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
@property (weak, nonatomic) IBOutlet UIView *bottomView;//pickView底部视图

@end

@implementation QuoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self offerRequest];
    [self selectOfferRequest];
    [self dataInitialize];
    [self uiLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//关于数据的初始化
-(void)dataInitialize{
    _startTime = [NSDate.date timeIntervalSince1970];
    _arrTime = [NSDate.dateTomorrow timeIntervalSince1970];
    _selectOfferArr = [NSMutableArray new];
}

//关于界面的操作
-(void)uiLayout{
    //去掉tableView底部多余的线
    self.tableView.tableFooterView = [UITableView new];
}

//监听到选择城市的通知后做什么
-(void)resetHome:(NSNotification *)notification{
    //NSLog(@"监听到了");
    //拿到通知所携带的参数
    NSString *city = notification.object;
    //非空检查
    if (![[Utilities getUserDefaults:@"UserCity"] isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"UserCity"] != nil) {
            //判断选择到的城市名和当前页面显示的城市名是否一致
            if (![[Utilities getUserDefaults:@"UserCity"] isEqualToString:city]) {
                //不但要替换掉城市按钮的标题，而且还要替换单例化全局变量中的值
                [Utilities removeUserDefaults:@"UserCity"];
                [Utilities setUserDefaults:@"UserCity" content:city];
            }
        }
    }
}

#pragma mark -request
//发布
-(void)offerRequest{
    double price=[_priceTextField.text doubleValue];//价格
    NSInteger weight=[_weightTextField.text integerValue];//重量
    NSString *airlines=_airlinesTextField.text;//航空公司
    NSString *intimestr=_departuretimeBtn.titleLabel.text;//出发时间
    NSString *aviationcabin=_spaceTextField.text;//舱位
    NSString *outtimestr=_arrivaltime.titleLabel.text;//到达时间
    NSString *departurestr=_startBtn.titleLabel.text;//出发地
    NSString *destinationstr=_endBtn.titleLabel.text;//目的地
    NSString *flightNostr=_flightTextField.text;//航班
    
    NSDictionary *para=@{@"business_id":@2,@"aviation_demand_id":[[StorageMgr singletonStorageMgr]objectForKey:@"id"],@"final_price":@(price),@"weight":@(weight),@"aviation_company":airlines,@"aviation_cabin":aviationcabin,@"in_time_str":intimestr,@"out_time_str":outtimestr,@"departure":departurestr,@"destination":destinationstr,@"flight_no":flightNostr};
    [RequestAPI requestURL:@"/offer_edu" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        
        [_tableView reloadData];
    } failure:^(NSInteger statusCode, NSError *error) {}];
}

//查询
-(void)selectOfferRequest{
    [RequestAPI requestURL:@"/selectOffer_edu" withParameters:@{@"Id":[[StorageMgr singletonStorageMgr]objectForKey:@"id"]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSArray *list=responseObject[@"content"];
        [_selectOfferArr removeAllObjects];
        for(NSDictionary *result in list){
            SelectOfferModel *offer=[[SelectOfferModel alloc]initWithDict:result];
            [_selectOfferArr addObject:offer];
        }
        [_tableView reloadData];
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"失败");
    }];
}

//删除
- (void)deleteRequest:(NSIndexPath *)indexPath {
    SelectOfferModel *seModel = _selectOfferArr[indexPath.row];
    NSDictionary *para = @{@"id":@(seModel.ID)};
    [RequestAPI requestURL:@"/deleteHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
    } failure:^(NSInteger statusCode, NSError *error) {
    }];
}

#pragma mark - TableView

//每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _selectOfferArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    SelectOfferModel *selectOfferModel =_selectOfferArr[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *inTime = selectOfferModel.inTimeStr;
    NSString *outTime = selectOfferModel.outTimeStr;
    cell.startTimeLabel.text = outTime;
    cell.endTimeLabel.text = inTime;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%ld",(long)selectOfferModel.price];
    cell.flightLabel.text = selectOfferModel.flightNo;
    cell.weightLabel.text = [NSString stringWithFormat:@"%ldkg",(long)selectOfferModel.weight];
    cell.airlinesLabel.text = selectOfferModel.aviationCompany;
    cell.spaceLabel.text = selectOfferModel.aviationCabin;
    cell.startLabel.text = selectOfferModel.departure;
    cell.endLabel.text = selectOfferModel.destination;
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

//编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该条航空发布吗?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteRequest:indexPath];
            [_selectOfferArr removeObjectAtIndex:indexPath.row];//删除数据
            //移除tableView中的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        }];
        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:actionA];
        [alert addAction:actionB];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//修改delete按钮文字为“删除”
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return @"删除";
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
    _bottomView.hidden = YES;
}

- (IBAction)yesAction:(UIBarButtonItem *)sender {
    _bottomView.hidden = YES;
}

- (IBAction)departuretime:(UIButton *)sender forEvent:(UIEvent *)event {
    _bottomView.hidden = NO;
}

- (IBAction)arrivaltime:(UIButton *)sender forEvent:(UIEvent *)event {
    _bottomView.hidden = NO;
}

- (IBAction)confirmAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([_priceTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_endBtn.titleLabel.text isEqualToString:@"选择目的地"]){
        [Utilities popUpAlertViewWithMsg:@"请填写目的地" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_airlinesTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写航空公司" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_startBtn.titleLabel.text isEqualToString:@"选择出发地"]){
        [Utilities popUpAlertViewWithMsg:@"请填写出发地" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_flightTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写航班" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_spaceTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写舱位" andTitle:@"提示" onView:self onCompletion:^{}];
     } else if([_departuretimeBtn.titleLabel.text isEqualToString:@"选择起飞日期 时间"]){
        [Utilities popUpAlertViewWithMsg:@"请填写起飞日期，时间" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_arrivaltime.titleLabel.text isEqualToString:@"选择到达日期 时间"]){
        [Utilities popUpAlertViewWithMsg:@"请填写到达日期,时间" andTitle:@"提示" onView:self onCompletion:^{}];
    } else if([_weightTextField.text isEqualToString:@""]){
        [Utilities popUpAlertViewWithMsg:@"请填写行李重量" andTitle:@"提示" onView:self onCompletion:^{}];
    } else{
        [self offerRequest];
        [_startBtn setTitle:@"选择出发地" forState:UIControlStateNormal];
        [_endBtn setTitle:@"选择目的地" forState:UIControlStateNormal];
        [_departuretimeBtn setTitle:@"选择出发日期" forState:UIControlStateNormal];
        [_arrivaltime setTitle:@"选择到达日期" forState:UIControlStateNormal];
        _spaceTextField.text = @"";
        _priceTextField.text = @"";
        _airlinesTextField.text = @"";
        _flightTextField.text = @"";
        _weightTextField.text = @"";
        [self selectOfferRequest];
    }
}
- (IBAction)endAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"offerToCity" sender:nil];
    //监听选择城市后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetHome:) name:@"ResetHome" object:nil];
}

- (IBAction)startAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"offerToCity" sender:nil];
    //监听选择城市后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetHome:) name:@"ResetHome" object:nil];
}
@end
