//
//  QuoteTableViewCell.h
//  GetHotels
//
//  Created by admin1 on 2017/11/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;//出发地
@property (weak, nonatomic) IBOutlet UILabel *endLabel;//目的地
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *airlinesLabel;//航空公司
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;//航班
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;//重量
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//起飞时间
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;//舱位
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//到达时间

@end
