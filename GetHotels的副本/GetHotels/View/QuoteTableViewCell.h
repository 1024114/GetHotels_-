//
//  QuoteTableViewCell.h
//  GetHotels
//
//  Created by admin1 on 2017/11/8.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *airlinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *flightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end
