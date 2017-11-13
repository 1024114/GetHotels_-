//
//  SelectOfferModel.m
//  GetHotels
//
//  Created by admin1 on 2017/11/13.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "SelectOfferModel.h"

@implementation SelectOfferModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        self.price = [[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:0] integerValue];
        self.weight = [[Utilities nullAndNilCheck:dict[@"weight"] replaceBy:0] integerValue];
        self.aviationCompany = [Utilities nullAndNilCheck:dict[@"aviation_company"] replaceBy:@"未知公司"];
        self.aviationCabin = [Utilities nullAndNilCheck:dict[@"aviation_cabin"] replaceBy:@"未知"];
        self.inTimeStr = [Utilities nullAndNilCheck:dict[@"in_time_str"] replaceBy:@""];
        self.outTimeStr = [Utilities nullAndNilCheck:dict[@"out_time_str"] replaceBy:@""];
        self.departure = [Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@"未知出发地"];
        self.destination = [Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@"未知目的地"];
        self.flightNo = [Utilities nullAndNilCheck:dict[@"flight_no"] replaceBy:@"未知"];
        self.ID = [[Utilities nullAndNilCheck:dict[@"id"] replaceBy:0]integerValue];
    }
    return self;
}
@end
