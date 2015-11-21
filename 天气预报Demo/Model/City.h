//
//  City.h
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, assign) int cityId;
@property (nonatomic, copy) NSString *cityName;

@end
