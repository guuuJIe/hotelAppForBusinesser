//
//  lookOfferModel.m
//  hotelApp
//
//  Created by admin2017 on 2017/9/6.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "lookOfferModel.h"

@implementation lookOfferModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _Id =[Utilities nullAndNilCheck:dict[@"id"] replaceBy:@""];
        _cabin =[Utilities nullAndNilCheck:dict[@"aviation_cabin"] replaceBy:@""];
        _company =[Utilities nullAndNilCheck:dict[@"aviation_company"] replaceBy:@""];
        _departure =[Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination =[Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _price =[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""];
        _startTime = [dict[@"in_time"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"in_time"]integerValue];
        _endTime = [dict[@"out_time"]isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"out_time"]integerValue];
        //_startTime =[Utilities nullAndNilCheck:dict[@"in_time"] replaceBy:@""];
        //_endTime =[Utilities nullAndNilCheck:dict[@"out_time"] replaceBy:@""];
        _weight =[Utilities nullAndNilCheck:dict[@"weight"] replaceBy:@""];

    }
    
    return self;
    
}


@end
