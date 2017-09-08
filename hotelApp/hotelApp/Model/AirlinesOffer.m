//
//  AirlinesOffer.m
//  hotelApp
//
//  Created by admin2017 on 2017/9/4.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "AirlinesOffer.h"

@implementation AirlinesOffer
-(instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _date =[dict[@"start_time"] isKindOfClass:[NSNull class]] ? (NSTimeInterval)0 : (NSTimeInterval)[dict[@"start_time"]integerValue] ;
        _airlines =[Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        _finalPrice =[Utilities nullAndNilCheck:dict[@"low_price"] replaceBy:@""];
        _highPrice =[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        _origin =[Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination =[Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _detail =[Utilities nullAndNilCheck:dict[@"aviation_demand_detail"] replaceBy:@""];
    }
    
    return self;
    
}

@end
