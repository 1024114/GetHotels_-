//
//  offerModel.h
//  GetHotels
//
//  Created by admin1 on 2017/11/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface offerModel : NSObject

@property(strong,nonatomic)NSString *date;//日期
@property(strong,nonatomic)NSString *price;//价格
@property(strong,nonatomic)NSString *time;//时间
@property(strong,nonatomic)NSString *space;//舱位
@property(strong,nonatomic)NSString *start;//出发地
@property(strong,nonatomic)NSString *end;//目的地
@property(strong,nonatomic)NSString *airlines;//航空公司

- (instancetype)initWithDict: (NSDictionary *)dict;



@end
