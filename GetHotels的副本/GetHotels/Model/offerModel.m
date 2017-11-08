//
//  offerModel.m
//  GetHotels
//
//  Created by admin1 on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "offerModel.h"

@implementation offerModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self){
        _lowTime = [Utilities nullAndNilCheck:dict[@"set_low_time_str"] replaceBy:@"未知时间"];//最早时间
        _highTime = [Utilities nullAndNilCheck:dict[@"set_high_time_str"] replaceBy:@"未知时间"];//最晚时间
        _space = [Utilities nullAndNilCheck:dict[@""] replaceBy:@"未知舱位"];//舱位
        _title = [Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@"未知地点"];//标题
        _start = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"未知地点"];//出发地
        _end = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"未知地点"];//目的地
        _highPrice = [Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@"0"];//最高价
        _lowPrice = [Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@"0"];//最低价
        _weight = [Utilities nullAndNilCheck:dict[@"weight"] replaceBy:@"0"];//重量
        _airID = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""] integerValue];//航班ID
    }
    return self;
}

@end
