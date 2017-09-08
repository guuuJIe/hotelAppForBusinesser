//
//  HotelIssueModel.h
//  hotelApp
//
//  Created by mac on 2017/9/7.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelModel : NSObject

@property (nonatomic) NSInteger businessId;
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelType;
@property (strong, nonatomic) NSString *hotelImgs;

- (instancetype)initWithDict: (NSDictionary *)dict;

@end
