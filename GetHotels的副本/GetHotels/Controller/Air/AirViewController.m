//
//  AirViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/10/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AirViewController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "AirTableViewCell.h"


@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger offerFlag;
    NSInteger cantOfferFlag;
    NSInteger offerPageNum;
    BOOL offerLast;
    NSInteger cantOfferPageNum;
    BOOL cantOfferLast;
    NSInteger type;
    NSInteger offerPageSize;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UITableView *staleTableView;
//自定义可变数组
@property (strong, nonatomic) NSMutableArray *offerarr;
@property (strong, nonatomic) NSMutableArray *cantOfferarr;

@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self navigationConfiguration];
    //界面设置
    [self uiLayout];
    [self dataInitialize];
    [self segmentedControlset];
    [self request];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInitialize{
    //初始可变化数组
    offerFlag=1;
    offerPageNum=1;
    _offerarr=[NSMutableArray new];
}

-(void)uiLayout{
    
}

//设置导航栏的方法
- (void)navigationConfiguration{
    //设置导航栏标题颜色
    //创建一个属性字典
    NSDictionary *titleTextOption = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //将上述的数字字典配置给导航栏的标题
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextOption];
    //更改导航栏的标题
    self.navigationItem.title = @"航空";
    //设置导航栏颜色（风格颜色：导航栏整体的背景色和状态栏整体的背景色）
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.f/255.f green:124.f/255.f blue:246.f/255.f alpha:1];
    //配置导航栏的毛玻璃效果 YES表示有  NO表示没有
    [self.navigationController.navigationBar setTranslucent:YES];
    //设置导航栏是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    //配置导航栏上的item的风格颜色（如果是文字则文字变成白色，如果是图片则图片的透明部分变成白色）
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //自定义返回按钮
    //self.navigationController.navigationItem.leftBarButtonItem = ;
}


-(void)segmentedControlset{
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    // Tying up the segmented control to a scroll view
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 60, viewWidth, 50)];
    self.segmentedControl4.sectionTitles = @[@"可报价", @"已过期"];
    self.segmentedControl4.selectedSegmentIndex = 1;
    //颜色
    self.segmentedControl4.backgroundColor = [UIColor colorWithRed:41.f/255.f green:124.f/255.f blue:246.f/255.f alpha:1];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.tag = 3;
    
    __weak typeof(self) weakSelf = self;
    [self.segmentedControl4 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl4];
    
}

#pragma mark - Request
-(void)request{
    NSDictionary *para=@{@"type":@1,@"pageNum":@(offerPageNum),@"pageSize":@5};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject=%@",responseObject);
        NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
        NSArray *list=result[@"list"];
        offerLast=[result[@"isLastPage"]boolValue];
        if(offerPageNum==1){
            [_offerarr removeAllObjects];
        }
        for(NSDictionary *dict in list){
            offerModel *offModel=[[offerModel alloc]initWithDict:dict];
            [_offerarr addObject:offModel];
        }
            [_offerTableView reloadData];
        }
     failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"失败");
    }];
}

#pragma mark - TableView

//每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _offerarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _offerTableView) {
        //通过细胞的Identifier拿到对应的细胞
        AirTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        offerModel *offModel = _offerarr[indexPath.section];
        //字符串的操作
        NSString *startTimeStr1 = [offModel.startTime substringFromIndex:11];
        NSString *startTimeStr2 = [startTimeStr1 substringToIndex:2];
        NSString *startDate1 = [offModel.startTime substringFromIndex:5];
        NSString *startDate2 = [startDate1 substringToIndex:5];
        //设置细胞显示的值
        cell.startLabel.text = offModel.start;
        cell.endLabel.text = offModel.end;
        cell.priceLabel.text = [NSString stringWithFormat:@"价格区间:¥%@———%@",offModel.lowPrice,offModel.highPrice];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@时左右",startTimeStr2];
        cell.dateLabel.text = startDate2;
        cell.airlinesLabel.text = offModel.airlines;
        return cell;
    }
    return nil;
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

@end
