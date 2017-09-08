//
//  AirlinesOffer.h
//  hotelApp
//
//  Created by admin2017 on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AirlinesOffer : NSObject
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *airlines;
@property (strong,nonatomic) NSString *origin;
@property (strong,nonatomic) NSString *destination;
@property (strong,nonatomic) NSString *finalPrice;
@property (strong,nonatomic) NSString *highPrice;
@property (strong,nonatomic) NSString *specificTime;
@property (strong,nonatomic) NSString *detail;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
