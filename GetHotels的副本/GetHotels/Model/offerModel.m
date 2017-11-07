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
        _date = [Utilities nullAndNilCheck:dict[@"date"] replaceBy:@"未知日期"];
        _time = [Utilities nullAndNilCheck:dict[@"time"] replaceBy:@"未知时间"];
        _lowPrice = [Utilities nullAndNilCheck:dict[@"price"] replaceBy:@"0"];
        _space = [Utilities nullAndNilCheck:dict[@"space"] replaceBy:@"未知舱位"];
        _start = [Utilities nullAndNilCheck:dict[@"start"] replaceBy:@"未知地点"];
    }
    return self;
}

@end
