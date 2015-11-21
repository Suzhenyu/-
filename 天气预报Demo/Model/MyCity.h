//
//  MyCity.h
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCity : NSObject

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityWeatherImg;
@property (nonatomic, copy) NSString *cityTemperature;
@property (nonatomic, copy) NSString *cityPM2d5;
@property (nonatomic, copy) NSString *cityPM2d5Level;

@end
