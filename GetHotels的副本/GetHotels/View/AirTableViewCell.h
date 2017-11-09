//
//  AirTableViewCell.h
//  GetHotels
//
//  Created by admin1 on 2017/11/2.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AirTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
@property (weak, nonatomic) IBOutlet UILabel *startLabel;//出发地
@property (weak, nonatomic) IBOutlet UILabel *endLabel;//目的地
@property (weak, nonatomic) IBOutlet UILabel *airlinesLabel;//航空公司

@end
