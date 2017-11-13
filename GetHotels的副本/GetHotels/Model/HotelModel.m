//
//  HotelModel.m
//  GetHotels
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel

//实现自定义的实例化方法
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        //给属性赋值
        //通过Utilities里的nullAndNilCheck:replaceBy:这个方法来对数据就行非空检查
        _hotelID = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""] integerValue];//酒店id
        _hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@"未知酒店名"];//酒店名称
        _hotelDescribe = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@"未知"];//描述
        //_hotelArea = [Utilities nullAndNilCheck:dict[@"id"] replaceBy:@"0"];//面积
        _hotelPrice = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:0];//价格
        _hotelImage = [Utilities nullAndNilCheck:dict[@"hotel_img"] replaceBy:@"png2"];//酒店首页图片
        _roomImage = [Utilities nullAndNilCheck:dict[@"room_img"] replaceBy:@"png2"];//房间图片
    }
    return self;
}
@end
