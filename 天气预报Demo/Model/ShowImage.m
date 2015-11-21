//
//  ShowImage.m
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ShowImage.h"

static ShowImage *singleInstance=nil;

@implementation ShowImage

+(ShowImage *)shareShaowImage{
    if (singleInstance==nil) {
        singleInstance=[[ShowImage alloc] init];
    }
    return singleInstance;
}

-(NSString *)selectImageNameByWeatherStr:(NSString *)str{
    if ([str isEqualToString:@"晴（白天）"]) {
        return @"w0";
    }else if ([str isEqualToString:@"晴"]) {
        return @"w0";
    }else if ([str isEqualToString:@"多云（白天）"]) {
        return @"w1";
    }else if ([str isEqualToString:@"多云"]) {
        return @"w1";
    }else if ([str isEqualToString:@"阴"]) {
        return @"w2";
    }else if ([str isEqualToString:@"阵雨（白天）"]) {
        return @"w3";
    }else if ([str isEqualToString:@"阵雨"]) {
        return @"w3";
    }else if ([str isEqualToString:@"雷阵雨"]) {
        return @"w4";
    }else if ([str isEqualToString:@"雷阵雨伴有冰雹"]) {
        return @"w5";
    }else if ([str isEqualToString:@"雨夹雪"]) {
        return @"w6";
    }else if ([str isEqualToString:@"小雨"]) {
        return @"w7";
    }else if ([str isEqualToString:@"中雨"]) {
        return @"w8";
    }else if ([str isEqualToString:@"大雨"]) {
        return @"w9";
    }else if ([str isEqualToString:@"暴雨"]) {
        return @"w10";
    }else if ([str isEqualToString:@"阵雪（白天）"]) {
        return @"w13";
    }else if ([str isEqualToString:@"阵雪"]) {
        return @"w13";
    }else if ([str isEqualToString:@"小雪"]) {
        return @"w14";
    }else if ([str isEqualToString:@"中雪"]) {
        return @"w15";
    }else if ([str isEqualToString:@"大雪"]) {
        return @"w16";
    }else if ([str isEqualToString:@"暴雪"]) {
        return @"w17";
    }else if ([str isEqualToString:@"雾（白天）"]) {
        return @"w18";
    }else if ([str isEqualToString:@"雾"]) {
        return @"w18";
    }else if ([str isEqualToString:@"冰雨"]) {
        return @"w19";
    }else if ([str isEqualToString:@"沙尘暴（白天）"]) {
        return @"w20";
    }else if ([str isEqualToString:@"沙尘暴"]) {
        return @"w20";
    }else if ([str isEqualToString:@"扬沙（白天）"]) {
        return @"w29";
    }else if ([str isEqualToString:@"扬沙"]) {
        return @"w29";
    }else if ([str isEqualToString:@"晴（夜间）"]) {
        return @"w30";
    }else if ([str isEqualToString:@"多云（夜间）"]) {
        return @"w31";
    }else if ([str isEqualToString:@"雾（夜间）"]) {
        return @"w32";
    }else if ([str isEqualToString:@"阵雨（夜间）"]) {
        return @"w33";
    }else if ([str isEqualToString:@"阵雪（夜间）"]) {
        return @"w34";
    }else if ([str isEqualToString:@"扬沙（夜间）"]) {
        return @"w35";
    }else if ([str isEqualToString:@"强扬沙（夜间）"]) {
        return @"w36";
    }else if ([str isEqualToString:@"霾"]) {
        return @"w45";
    }else{
        return @"error";
    }
    
}

-(NSString *)selectImageNameByPM2d5Level:(NSString *)str{
    if ([str isEqualToString:@"1"]) {
        return @"pm2d5_1";
    }else if ([str isEqualToString:@"2"]) {
        return @"pm2d5_2";
    }else if ([str isEqualToString:@"3"]) {
        return @"pm2d5_3";
    }else if ([str isEqualToString:@"4"]) {
        return @"pm2d5_4";
    }else {
        return @"pm2d5_5";
    }
}

-(NSString *)selectImageNameByPM25Level:(int)level{
    switch (level) {
        case 1:
            return @"pm2d5_1";
            break;
        case 2:
            return @"pm2d5_2";
            break;
        case 3:
            return @"pm2d5_3";
            break;
        case 4:
            return @"pm2d5_4";
            break;
        case 5:
            return @"pm2d5_5";
            break;
        default:
            return @"error";
            break;
    }
    return nil;
}

@end
