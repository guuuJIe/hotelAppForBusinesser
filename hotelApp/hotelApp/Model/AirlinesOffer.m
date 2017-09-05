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
        _date =[Utilities nullAndNilCheck:dict[@"set_low_time"] replaceBy:@""];
        _airlines =[Utilities nullAndNilCheck:dict[@"aviation_demand_title"] replaceBy:@""];
        _finalPrice =[Utilities nullAndNilCheck:dict[@"final_price"] replaceBy:@""];
        _highPrice =[Utilities nullAndNilCheck:dict[@"high_price"] replaceBy:@""];
        _origin =[Utilities nullAndNilCheck:dict[@"departure"] replaceBy:@""];
        _destination =[Utilities nullAndNilCheck:dict[@"destination"] replaceBy:@""];
        _specificTime =[Utilities nullAndNilCheck:dict[@""] replaceBy:@""];
    }
    
    return self;
    
}

@end
