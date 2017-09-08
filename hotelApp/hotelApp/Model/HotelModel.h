//
//  HotelIssueModel.h
//  hotelApp
//
//  Created by mac on 2017/9/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

@property (nonatomic) NSInteger Id;  //酒店id
@property (strong, nonatomic) NSString *businessId;
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelType;
@property (strong, nonatomic) NSString *hotelImgs;
@property (nonatomic) NSInteger price;


- (instancetype)initWithDict: (NSDictionary *)dict;

@end
