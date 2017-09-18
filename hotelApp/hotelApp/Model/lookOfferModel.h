//
//  lookOfferModel.h
//  hotelApp
//
//  Created by admin2017 on 2017/9/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lookOfferModel : NSObject
@property (strong,nonatomic) NSString *Id;
@property (strong,nonatomic) NSString *cabin;
@property (strong,nonatomic) NSString *company;
@property (strong,nonatomic) NSString *departure;
@property (strong,nonatomic) NSString *destination;
@property (strong,nonatomic) NSString *price;
@property (nonatomic)NSTimeInterval startTime;
@property (nonatomic)NSTimeInterval endTime;
@property (strong,nonatomic) NSString *weight;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
