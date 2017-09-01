//
//  offerTableViewCell.h
//  hotelApp
//
//  Created by admin2017 on 2017/9/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface offerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *luggageLabel;

@end
