//
//  StaleModel.h
//  GetHotels
//
//  Created by admin1 on 2017/11/9.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaleModel : NSObject
@property (nonatomic) NSInteger airID;//航空id
@property(strong,nonatomic)NSString *lowPrice;//最低价格
@property(strong,nonatomic)NSString *highPrice;//最高价格
@property(strong,nonatomic)NSString *lowTime;//最低时间
@property(strong,nonatomic)NSString *highTime;//最高时间
@property(strong,nonatomic)NSString *space;//舱位
@property(strong,nonatomic)NSString *title;//标题
@property(strong,nonatomic)NSString *start;//出发地
@property(strong,nonatomic)NSString *end;//目的地
@property(strong,nonatomic)NSString *startTime;//出发时间

- (instancetype)initWithDict: (NSDictionary *)dict;
@end
