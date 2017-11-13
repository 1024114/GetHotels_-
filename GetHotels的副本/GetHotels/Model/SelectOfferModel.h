//
//  SelectOfferModel.h
//  GetHotels
//
//  Created by admin1 on 2017/11/13.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectOfferModel : NSObject

@property(nonatomic)NSInteger price;
@property(nonatomic)NSInteger weight;
@property(strong,nonatomic)NSString *aviationCompany;
@property(strong,nonatomic)NSString *aviationCabin;
@property(strong,nonatomic)NSString *inTimeStr;
@property(strong,nonatomic)NSString *outTimeStr;
@property(strong,nonatomic)NSString *departure;
@property(strong,nonatomic)NSString *destination;
@property(strong,nonatomic)NSString *flightNo;
@property(nonatomic)NSInteger ID;

-(instancetype)initWithDict:(NSDictionary *)dict;
@end
