//
//  ShowImage.h
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowImage : NSObject

+(ShowImage *)shareShaowImage;

/**
 *  根据天气状况给出相应的图片名称
 */
-(NSString *)selectImageNameByWeatherStr:(NSString *)str;

/**
 *  根据PM2.5等级给出相应图片名称
 */
//-(NSString *)selectImageNameByPM2d5Level:(NSString *)str;

-(NSString *)selectImageNameByPM25Level:(int)level;

@end
