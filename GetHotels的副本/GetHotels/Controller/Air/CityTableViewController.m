//
//  CityTableViewController.m
//  GetHotels
//
//  Created by admin1 on 2017/11/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "CityTableViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CityTableViewController ()<CLLocationManagerDelegate>{
    BOOL firstVisit;
}
@property (strong, nonatomic) NSMutableDictionary *citiesDict;
@property (strong, nonatomic) NSMutableArray *keys;
//声明一个定位管理器
@property (strong, nonatomic) CLLocationManager *locationMgr;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation CityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//用来执行数据的初始化
-(void)dataInitialize{
    //初始化全局变量
    _citiesDict = [NSMutableDictionary new];
    _keys = [NSMutableArray new];
    firstVisit = YES;
    
    //通过沙盒拿到文件的路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Cities" ofType:@"plist"];
    //NSLog(@"filePath = %@",filePath);
    //初始化一个文件管理器
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:filePath]) {
        //根据上述的文件路径下的文件内容读取到一个字典对象中（因为我们知道要读取的文件是plist格式，所以用字典承接）
        NSDictionary *fileContent = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if (!fileContent) {
            return;
        }
        //将上述字典赋值给全局的可变字典
        _citiesDict = (NSMutableDictionary *)fileContent;
        //NSLog(@"fileContent = %@",fileContent);
        //将上述字典中的键全部读取到数组中
        NSArray *keyArray = [fileContent allKeys];
        //NSLog(@"keyArray = %@",keyArray);
        //将上述所有键的数组进行升序排序，赋值给全局的可变数组
        _keys = (NSMutableArray *)[keyArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    }
}

//用来做关于界面的操作
-(void)uiLayout{
    //去掉tableView底部多余的线
    self.tableView.tableFooterView = [UITableView new];
    //设置导航栏的标题
    self.navigationController.navigationItem.title = @"选择城市";
}

#pragma mark - Location
//设置定位管理器的方法
-(void)locationConfig{
    //初始化定位管理器
    _locationMgr = [[CLLocationManager alloc] init];
    //签协议
    _locationMgr.delegate = self;
    //设置更新位置的距离，当移动超过这个这个距离的时候就会更新位置，否则不会更新位置,kCLDistanceFilterNone表示不设置距离过滤，即随时更新位置
    _locationMgr.distanceFilter = kCLDistanceFilterNone;
    //定位的精确度,kCLLocationAccuracyBest最精确
    _locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
}

//判断用户授权
-(void)getUserLocation{
    //判断用户如果没有选择定位功能
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
#ifdef __IPHONE_8_0
        //判断_locationMgr是否对requestWhenInUseAuthorization（询问用户授权）响应
        if ([_locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            //询问用户是否开启定位功能
            [_locationMgr performSelector:@selector(requestWhenInUseAuthorization)];
        }
#endif
    }
    //开始定位
    [_locationMgr startUpdatingLocation];
}

//位置更新后调用
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"new = %@",newLocation);
    //将当前更新后的位置存在全局变量中
    _location = newLocation;
    if (firstVisit) {
        //调用反向地理编码的方法
        [self seachReGeocodeWithLacation];
        firstVisit = NO;
    }
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    //判断错误是否存在
    if (error) {
        //调用定位失败的处理方法
        [self errorCheck:error];
    }
}

//定位失败的处理
-(void)errorCheck:(NSError *)error{
    switch ([error code]) {
            //网络错误
        case kCLErrorNetwork:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetWorkError",nil) andTitle:@"提示" onView:self onCompletion:^{}];
            break;
        case kCLErrorDenied:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled",nil) andTitle:@"提示" onView:self onCompletion:^{}];
            break;
        case kCLErrorLocationUnknown:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnknow",nil) andTitle:@"提示" onView:self onCompletion:^{}];
            break;
            
        default:
            [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError",nil) andTitle:@"提示" onView:self onCompletion:^{}];
            break;
    }
}

//地理编码
-(void)seachReGeocodeWithLacation{
    //设置一个延迟的时间
    dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC);
    //延迟一段时间执行
    dispatch_after(poptime, dispatch_get_main_queue(), ^{
        //创建一个地理编码的对象
        CLGeocoder *reGeo = [[CLGeocoder alloc] init];
        //使用反向地理编码的方法
        [reGeo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (!error && placemarks.count > 0) {
                //将位置信息提取出来
                CLPlacemark *pl = placemarks[0];
                //拿到城市名
                NSString *city = [pl.locality substringToIndex:pl.locality.length - 1];
                //把城市名存入单例化的全局变量中
                [Utilities removeUserDefaults:@"LocCity"];
                [Utilities setUserDefaults:@"LocCity" content:city];
            }
        }];
        //停止定位
        [_locationMgr stopUpdatingLocation];
    });
    
}


#pragma mark - Table view data source
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _keys.count;
}
//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //根据组号拿到对应的首写字母
    NSString *key = _keys[section];
    //根据上述键名，拿到首字母对应的城市的数组
    NSArray *cities = [_citiesDict objectForKey:key];
    return cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //通过Identifier拿到对应的细胞
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
    //根据组号拿到对应的首写字母
    NSString *key = _keys[indexPath.section];
    //根据上述键名，拿到首字母对应的城市的数组
    NSArray *cities = [_citiesDict objectForKey:key];
    NSDictionary *city = cities[indexPath.row];
    //设置元素的属性
    cell.textLabel.text = city[@"name"];
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return _keys[section];
}

//每组头部视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}

//设置tableView右侧快捷栏
- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _keys;
}

//选中行时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消当前选中行的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //通过当前选中的组号拿到对应的组标题(键名)
    NSString *key = _keys[indexPath.section];
    //通过上述键名拿到组标题对应的城市数组
    NSArray *cities = [_citiesDict objectForKey:key];
    //通过行号拿到当前选中行所对应的数据
    NSDictionary *city = cities[indexPath.row];
    //注册一个通知
    NSNotification *notification = [NSNotification notificationWithName:@"ResetHome" object:city[@"name"]];
    //发送通知
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
    //返回上个页面
    [self.navigationController popViewControllerAnimated:YES];
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

@end
