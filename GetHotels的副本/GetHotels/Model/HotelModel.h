//
//  HotelModel.h
//  GetHotels
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

@property (nonatomic) NSInteger hotelID;//酒店id
@property (strong, nonatomic) NSString *hotelName;//酒店名称
@property (strong, nonatomic) NSString *hotelDescribe;//描述
@property (strong, nonatomic) NSString *hotelArea;//面积
@property (nonatomic) NSInteger hotelPrice;//价格
@property (strong, nonatomic) NSString *hotelImage;//酒店首页图片
@property (strong, nonatomic) NSString *roomName;//房间名称
@property (strong, nonatomic) NSString *roomImage;//房间图片
@property (strong, nonatomic) NSString *breakfast;//是否含早
@property (strong, nonatomic) NSString *badType;//床型
@property (strong, nonatomic) NSString *roomArea;//房间面积
@property (strong, nonatomic) NSString *roomPrice;//房间价格
@property (strong, nonatomic) NSString *week;//周末节假日加价
@property (strong, nonatomic) NSString *picker;//选择酒店

//声明一个自定义实例化方法
- (instancetype) initWithDict: (NSDictionary *)dict;
@end
