//
//  HotelTableViewController.m
//  GetHotels
//
//  Created by admin on 2017/11/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelTableViewController.h"


@interface HotelTableViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger hotelPageNum;
    NSInteger page;
    //BOOL hotelLast;
    //NSInteger type;
    
}
- (IBAction)postedBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (strong, nonatomic) UIRefreshControl *tag;
@property (strong, nonatomic) UIActivityIndicatorView *aiv;

//声明一个可变数组array
@property (strong, nonatomic) NSMutableArray *hotelarr;
@property (strong, nonatomic) NSMutableArray *resetArr;

@end

@implementation HotelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self navigationConfiguration];
    [self tableView];
    [self request];
    [self dataInitialize];
    [self uiLayout];
    [self createRefeshControll];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self request];
}

-(void)dataInitialize{
    //初始可变化数组
    hotelPageNum=1;
    _hotelarr = [NSMutableArray new];
    _resetArr = [NSMutableArray new];
}


#pragma mark - otherSetting
//创建刷新指示器
-(void)createRefeshControll{
    //创建刷新指示器
    UIRefreshControl *ref = [UIRefreshControl new];
    //给刷新指示器设置tag
    ref.tag = 101;
    //刷新开始的时候做什么（给刷新指示器添加事件）
    [ref addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    //将这个刷新指示器添加给tableView(刷新指示器会添加在tableView的上方居中的位置)
    [_tabelView addSubview:ref];
}

//刷新开始时做什么
-(void)refresh{
    //NSLog(@"开始刷新");
    //刷新的实质是：将重新请求第一页的数据
    hotelPageNum = 1;
    [self request];
    
}

//网络请求成功或失败后停止掉刷新动画
-(void)end{
    //通过tag拿到对应的控件
    UIRefreshControl *ref = (UIRefreshControl *)[_tabelView viewWithTag:101];
    //停止刷新
    [ref endRefreshing];
    //让蒙层停止转动
    [_aiv stopAnimating];
}



//设置导航栏的方法
- (void)navigationConfiguration{
    //设置导航栏标题颜色
    //创建一个属性字典
    NSDictionary *titleTextOption = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //将上述的数字字典配置给导航栏的标题
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextOption];
    //更改导航栏的标题
    self.navigationItem.title = NSLocalizedString(@"我的酒店", nil);
    //设置导航栏颜色（风格颜色：导航栏整体的背景色和状态栏整体的背景色）
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(14, 124, 246);
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

//用于做关于界面的操作
- (void)uiLayout{
    //去掉tableView底部多余的线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Request
-(void)request{
    NSDictionary *para=@{@"business_id":@1};
    //网络请求
    [RequestAPI requestURL:@"/findHotelBySelf" withParameters:para andHeader:nil byMethod:kPost andSerializer:kForm success:^(id responseObject) {
        [self end];
        NSLog(@"responseObject = %@",responseObject);
        //if ([responseObject[@"resultFlag"] integerValue] == 1) {
            //解析数据
            NSArray *list = responseObject[@"content"];
        if (hotelPageNum == 1) {
            [_hotelarr removeAllObjects];
        }
            //遍历上述数组拿到每条数据（每个字典）
            for(NSDictionary *dict in list){
                //将遍历得来的字典转换成model
                HotelModel *hotelModel=[[HotelModel alloc]initWithDict:dict];
                //将上述model放入可变数组中
                [_hotelarr addObject:hotelModel];
                //让tableView重载数据
                [self.tabelView reloadData];
            }
//        }else{
//            //业务逻辑失败的情况
//            [Utilities popUpAlertViewWithMsg:@"请求失败，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{}];
//        }

    } failure:^(NSInteger statusCode, NSError *error) {
        [_aiv stopAnimating];
        NSLog(@"失败");
    }];
}

//删除
-(void)deleteRequest:(NSIndexPath *)indexPath{
    HotelModel *hotelModel = _hotelarr[indexPath.row];
    NSDictionary *para = @{@"id":@(hotelModel.hotelID)};
    //网络请求
    [RequestAPI requestURL:@"/deleteHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"删除成功:房间编号 %ld", (long)hotelModel.hotelID);
    } failure:^(NSInteger statusCode, NSError *error) {
        NSLog(@"删除失败:%ld",(long)statusCode);
    }];
}

#pragma mark - Table view data source(关于细胞)
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _hotelarr.count;
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"room" forIndexPath:indexPath];
    HotelModel *hotelModel = _hotelarr[indexPath.row];
    NSString *str1 = [hotelModel.hotelDescribe substringFromIndex:2];//去掉最左边的["
    NSString *str2 = [str1 substringToIndex:str1.length - 2];//去掉最后的"]
    NSRange  range = [str2 rangeOfString:@","];//定义一个特殊符号 ","
    NSString *str3 = [str2 substringToIndex:range.location];//截取到特殊符号为止
    NSString *str4 = [str2 substringFromIndex:range.location];//从特殊符号开始截取
    NSString *str5 = [str4 substringFromIndex:range.length];//截取上一行的数据 - 特殊符号
    NSString *str6 = [str5 substringToIndex:range.location];//截取到特殊符号为止
    NSString *str7 = [str6 substringToIndex:str6.length - 3];//截取最后的3位特殊符号
    NSString *str8 = [str5 substringFromIndex:range.location];//从特殊符号开始截取
    NSString *str9 = [str8 substringFromIndex:range.length];//截取上一行的数据 - 特殊符号
    NSString *str10 = [str9 substringFromIndex:str9.length - 2];

    //设置细胞的值

    cell.nameLabel.text = hotelModel.hotelName;//酒店名称
    cell.describeLabel.text = [NSString stringWithFormat:@"描述:%@ %@",str3,str7];//描述
    cell.areaLabel.text = [NSString stringWithFormat:@"面积:%@㎡", str10];//面积
    cell.priceLabel.text= [NSString stringWithFormat:@"价格: %ld¥",(long)hotelModel.hotelPrice];//价格
    //    //图片远程路径字符串转换为NSURL
    //    NSURL *url = [NSURL URLWithString:hotelModel.roomImage];
    //    //依靠第三方SDwebImage来异步的根据某个图片网址下载图片，并且实现三级缓存到项目中，同时为下载图片的时间周期过程中设置一张默认图
    //    [cell.roomImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"png2"]];

    return cell;
}


//细胞的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.f;
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定删除该条发布?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            [self deleteRequest:indexPath];
            [_hotelarr removeObjectAtIndex:indexPath.row];//删除数据
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
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)postedBtn:(UIBarButtonItem *)sender {
}
@end
