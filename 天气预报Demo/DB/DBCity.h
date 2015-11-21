//
//  DBCity.h
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBCity : NSObject

+(DBCity *)shareCity;

/**
 *  通过city_id搜索对应的city_name
 *
 *  @param cityId 城市Id
 *
 *  @return 城市名称
 */
-(NSString *)selectCityNameWithCityId:(int)cityId;
/**
 *  查询数据库中所有的城市名
 *
 *  @return 返回一个包含所有城市名称的数组
 */
-(NSMutableArray *)selectAllCityName;
/**
 *  查询数据库中所有的城市名＋城市Id
 *
 *  @return 返回一个包含所有城市信息的数组
 */
-(NSMutableArray *)selectAllCityInfo;
/**
 *  添加新的城市(这个方法没有必要了)
 */
//-(BOOL)insertCity:(NSString *)cityName;

//SELECT * FROM citys WHERE cityName LIKE '%b%' OR cityCode LIKE '%bo%'
/**
 *  通过字母或文字查询与之相关的城市信息
 */
-(NSMutableArray *)selectCityInfoByStr:(NSString *)str;


@end
