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
#import "StaleTableViewCell.h"


@interface AirViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    NSInteger staleFlag;
    NSInteger offerPageNum;
    BOOL offerLast;
    NSInteger stalePageNum;
    BOOL staleLast;
    NSInteger type;
    NSInteger offerPageSize;
    NSInteger totalpage;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;
@property (weak, nonatomic) IBOutlet UITableView *offerTableView;
@property (weak, nonatomic) IBOutlet UITableView *staleTableView;
//自定义可变数组
@property (strong, nonatomic) NSMutableArray *offerArr;
@property (strong, nonatomic) NSMutableArray *staleerarr;
@property (strong, nonatomic) NSMutableArray *staleArr;
@property (strong, nonatomic)UIActivityIndicatorView *avi;
@property (strong, nonatomic)UIRefreshControl *tag;
@property (strong, nonatomic)UIRefreshControl *tag2;

@end

@implementation AirViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationConfiguration];
    [self uiLayout];
    [self dataInitialize];
    [self segmentedControlset];
    [self createRefeshControll];
    [self offerInitializeData];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dataInitialize{
    //初始可变化数组
    offerPageNum = 1;
    _offerArr = [NSMutableArray new];
    staleFlag = 1;
    stalePageNum = 1;
    _staleArr = [NSMutableArray new];
    
}

-(void)uiLayout{
    //去掉tableView底部多余的线
    self.offerTableView.tableFooterView = [UITableView new];
    self.staleTableView.tableFooterView = [UITableView new];
}

#pragma mark - otherSetting
//创建刷新指示器
-(void)createRefeshControll{
    //创建刷新指示器
    _tag = [UIRefreshControl new];
    //刷新开始的时候做什么（给刷新指示器添加事件）
    [_tag addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //将这个刷新指示器添加给tableView(刷新指示器会添加在tableView的上方居中的位置)
    [_offerTableView addSubview:_tag];
    //创建刷新指示器
    _tag2 = [UIRefreshControl new];
    //刷新开始的时候做什么（给刷新指示器添加事件）
    [_tag2 addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_staleTableView addSubview:_tag2];
}
//刷新开始时做什么
-(void)refresh{
    offerPageNum = 1;
    [self offerRequest];
    
}

//刷新开始时做什么
-(void)refresh2{
    stalePageNum = 1;
    [self staleRequest];
}

//网络请求成功或失败后停止掉刷新动画
-(void)end{
    //停止刷新
    [_tag endRefreshing];
    [_avi stopAnimating];
}

-(void)end2{
    //停止刷新
    [_tag2 endRefreshing];
    [_avi stopAnimating];
}
//滑动到可报价
-(void)offerInitializeData{
    _avi=[Utilities getCoverOnView:self.view];
    [self offerRequest];
    
}
//滑动到已过期
-(void)staleInitializeData{
    _avi=[Utilities getCoverOnView:self.view];
    [self staleRequest];
}


#pragma mark -scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if(scrollView==_scrollView){
        NSInteger page = [self scrollCheck:scrollView];
        [_segmentedControl4 setSelectedSegmentIndex:page animated:YES];
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (scrollView == _scrollView) {
        [self scrollCheck:scrollView];
    }
}
- (NSInteger)scrollCheck: (UIScrollView *)scrollView{
    NSInteger page = scrollView.contentOffset.x / (scrollView.frame.size.width);
    if(staleFlag==1 && page==1){
        staleFlag=0;
        [self staleInitializeData];
    }
    
    return page;
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
    self.segmentedControl4.selectedSegmentIndex = 0;
    //颜色
    self.segmentedControl4.backgroundColor = self.navigationController.navigationBar.barTintColor;
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor groupTableViewBackgroundColor]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.tag = 3;
    //把self转换成弱指针
    __weak typeof(self) weakSelf = self;
    //点击事件
    [self.segmentedControl4 setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segmentedControl4];
    
}

#pragma mark - Request
//首页可报价
-(void)offerRequest{
    NSDictionary *para=@{@"type":@1,@"pageNum":@(offerPageNum),@"pageSize":@10};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [self end];
        NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
        NSArray *list=result[@"list"];
        offerLast=[result[@"isLastPage"]boolValue];
        if(offerPageNum==1){
            [_offerArr removeAllObjects];
        }
        for(NSDictionary *dict in list){
            offerModel *offModel=[[offerModel alloc]initWithDict:dict];
            [_offerArr addObject:offModel];
        }
            [_offerTableView reloadData];
        }
     failure:^(NSInteger statusCode, NSError *error) {
         [self end];
        //NSLog(@"失败");
    }];
}


//首页已过期
-(void)staleRequest{
    NSDictionary *para=@{@"type":@0,@"pageNum":@(stalePageNum),@"pageSize":@10};
    [RequestAPI requestURL:@"/findAlldemandByType_edu" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [self end2];
        //NSLog(@"responseObject=%@",responseObject);
        NSDictionary *result=responseObject[@"content"][@"Aviation_demand"];
        NSArray *list=result[@"list"];
        staleLast=[result[@"isLastPage"]boolValue];
        if(stalePageNum==1){
            [_staleArr removeAllObjects];
        }
        for(NSDictionary *dict in list){
            StaleModel *staleModel=[[StaleModel alloc]initWithDict:dict];
            [_staleArr addObject:staleModel];
        }
        [_staleTableView reloadData];
    }
       failure:^(NSInteger statusCode, NSError *error) {
       [self end2];
       }];
}

#pragma mark - TableView

//设置多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == _offerTableView){
        return _offerArr.count;
    }
    else{
        return _staleArr.count;
    }
}

//每组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断是可报价还是已过期
    if (tableView == _offerTableView) {
        //通过细胞的Identifier拿到对应的细胞
        AirTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        offerModel *offModel = _offerArr[indexPath.section];
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
    } else if (tableView == _staleTableView){
        StaleTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"staleCell" forIndexPath:indexPath];
        StaleModel *staleModel = _staleArr[indexPath.section];
        //字符串的操作
        NSString *startTimeStr3 = [staleModel.startTime substringFromIndex:11];
        NSString *startTimeStr4 = [startTimeStr3 substringToIndex:2];
        NSString *startDate3 = [staleModel.startTime substringFromIndex:5];
        NSString *startDate4 = [startDate3 substringToIndex:5];
        //设置细胞显示的值
        cell.startLabel.text = staleModel.start;
        cell.endLabel.text = staleModel.end;
        cell.priceLabel.text = [NSString stringWithFormat:@"价格区间:¥%@———%@",staleModel.lowPrice,staleModel.highPrice];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@时左右",startTimeStr4];
        cell.dateLabel.text = startDate4;
        return cell;
    }
    return nil;
}

//细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

//选中行时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消当前选中行的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _offerTableView) {
        offerModel *off = _offerArr[indexPath.section];
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"id"];
        [[StorageMgr singletonStorageMgr]addKey:@"id" andValue:@(off.airID)];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//细胞将要出现的时候
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _staleArr.count - 1) {
        //判断数据还有没有下一页
        if (stalePageNum < totalpage) {
            //在这里请求下一页的数据
            stalePageNum ++ ;
            [self staleRequest];
        }
    } else if (indexPath.row == _offerArr.count - 1){
        if (offerPageNum < totalpage) {
            offerPageNum ++;
            [self offerRequest];
        }
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

@end
