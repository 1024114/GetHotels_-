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
    BOOL hotelLast;
    NSInteger type;
    
}
- (IBAction)postedBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tabelView;

//声明一个可变数组array
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *hotelarr;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dataInitialize{
    //初始可变化数组
    _array = [NSMutableArray new];
    hotelPageNum=1;
    _hotelarr=[NSMutableArray new];
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
        NSLog(@"responseObject = %@",responseObject);
        //if ([responseObject[@"resultFlag"] integerValue] == 1) {
            //解析数据
            NSArray *list = responseObject[@"content"];
            //遍历上述数组拿到每条数据（每个字典）
            
            for(NSDictionary *dict in list){
                //将遍历得来的字典转换成model
                HotelModel *hotelModel=[[HotelModel alloc]initWithDict:dict];
                NSLog(@"hotelName = %@", hotelModel.hotelName);
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
        NSLog(@"失败");
    }];
}

////删除
//-(void)deleteRequest{
//    NSDictionary *para=@{@"business_id":@1};
//    //网络请求
//    [RequestAPI requestURL:@"/deleteHotel" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//
//    } failure:<#^(NSInteger statusCode, NSError *error)failure#>];
//
//}

#pragma mark - Table view data source(关于细胞)

//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}


//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _hotelarr.count;
}

//每行长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"room" forIndexPath:indexPath];
    
    HotelModel *hotelModel = _hotelarr[indexPath.section];
    NSString *str1 = [hotelModel.hotelDescribe substringFromIndex:10];//含早","大床","38²"]
    NSString *str2 = [str1 substringFromIndex:5];//大床","38²"]
    NSString *str3 = [str1 substringToIndex:2];//含早
    NSString *str4 = [str2 substringToIndex:2];//大床
    NSString *str5 = [NSString stringWithFormat:@"描述:%@, %@",str3,str4];
    NSString *str6 = [str2 substringFromIndex:5];
    NSString *str7 = [str6 substringToIndex:4];
    //设置细胞的值
    cell.describeLabel.text = str5;
    cell.areaLabel.text = [NSString stringWithFormat:@"面积:%@", str7];
//    cell.priceLabel.text = hotelModel.hotelPrice;
    
    
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


////编辑
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView setEditing:NO animated:YES];
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该条航空发布吗?" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            [self deleteRequest:indexPath];
//            [_hotelarr removeObjectAtIndex:indexPath.row];//删除数据
//            //移除tableView中的数据
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//        }];
//        UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:actionA];
//        [alert addAction:actionB];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

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
