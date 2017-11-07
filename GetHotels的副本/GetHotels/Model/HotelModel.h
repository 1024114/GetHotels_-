//
//  HotelModel.h
//  GetHotels
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

@property (strong, nonatomic) NSString *name;//酒店名称
@property (strong, nonatomic) NSString *describe;//描述
@property (strong, nonatomic) NSString *area;//面积
@property (strong, nonatomic) NSString *price;//价格
//图片

//声明一个自定义实例化方法
- (instancetype) initWithDict: (NSDictionary *)dict;
- (instancetype) initwithDictForDetial:(NSDictionary *)dict;
@end
