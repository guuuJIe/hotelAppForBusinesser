//
//  ExpiredTableViewCell.h
//  hotelApp
//
//  Created by admin2017 on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpiredTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *overdueDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueOriginLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueTicketLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *overduePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planeImgView;

@end
