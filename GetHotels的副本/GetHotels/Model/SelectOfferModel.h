//
//  SelectOfferModel.h
//  GetHotels
//
//  Created by admin1 on 2017/11/13.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectOfferModel : NSObject

@property(nonatomic)NSInteger price;//价格
@property(nonatomic)NSInteger weight;//重量
@property(strong,nonatomic)NSString *aviationCompany;//航空公司
@property(strong,nonatomic)NSString *aviationCabin;//舱位
@property(strong,nonatomic)NSString *inTimeStr;//出发时间
@property(strong,nonatomic)NSString *outTimeStr;//到达时间
@property(strong,nonatomic)NSString *departure;//出发地
@property(strong,nonatomic)NSString *destination;//目的地
@property(strong,nonatomic)NSString *flightNo;//航班
@property(nonatomic)NSInteger ID;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
