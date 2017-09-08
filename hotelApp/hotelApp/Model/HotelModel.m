
//
//  HotelIssueModel.m
//  hotelApp
//
//  Created by mac on 2017/9/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "HotelModel.h"

@implementation HotelModel

- (instancetype)initWithDict: (NSDictionary *)dict {
    self = [super init];
    if (self) {
        _businessId = [[Utilities nullAndNilCheck:dict[@"business_id"] replaceBy:0] integerValue];
        _hotelName = [Utilities nullAndNilCheck:dict[@"hotel_name"] replaceBy:@""];
        _hotelType = [Utilities nullAndNilCheck:dict[@"hotel_type"] replaceBy:@""];
        _hotelImgs = [Utilities nullAndNilCheck:dict[@"room_imgs"] replaceBy:@""];
    }
    return self;
}

@end
