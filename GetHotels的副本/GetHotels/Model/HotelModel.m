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
        self.name = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@"未知酒店名"];
    }
    return self;
}
@end
