//
//  DBCity.m
//  天气预报Demo
//
//  Created by apple on 15/11/20.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DBCity.h"
#import "City.h"

static DBCity *singleInstance=nil;

@interface DBCity ()
{
    sqlite3 *_dbSqlite;
}

@end
@implementation DBCity

+(DBCity *)shareCity{
    if (singleInstance==nil) {
        singleInstance=[[DBCity alloc] init];
    }
    return singleInstance;
}

-(BOOL)openDB{
    NSString *pathStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    int result=sqlite3_open([[NSString stringWithFormat:@"%@/Citys.sqlite",pathStr] UTF8String], &_dbSqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    return YES;
}
-(BOOL)closeDB{
    int result=sqlite3_close(_dbSqlite);
    if (result!=SQLITE_OK) {
        NSLog(@"关闭数据库失败");
        return NO;
    }
    return YES;
}

#pragma mark  根据cityId查询cityName
-(NSString *)selectCityNameWithCityId:(int)cityId{
    NSString *str=[NSString string];
    if (![self openDB]) {
        NSLog(@"根据cityId查询cityName时打开数据库失败");
        return nil;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT cityName FROM citys WHERE id=%i",cityId];
    sqlite3_stmt *statment;
    int result=sqlite3_prepare_v2(_dbSqlite, [sqlStr UTF8String], -1, &statment, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"根据cityId查询cityName失败");
    }
    if (sqlite3_step(statment)==SQLITE_ROW) {
        str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 0)];
    }
    sqlite3_finalize(statment);
    
    if (![self closeDB]) {
        NSLog(@"根据city_id查询city_name时关闭数据库失败");
        return nil;
    }
    return str;
}

-(NSMutableArray *)selectAllCityName{
    NSMutableArray *arr=[NSMutableArray array];
    if (![self openDB]) {
        NSLog(@"查询所有cityName时打开数据库失败");
        return nil;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT cityName FROM citys"];
    sqlite3_stmt *statment;
    int result=sqlite3_prepare_v2(_dbSqlite, [sqlStr UTF8String], -1, &statment, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"查询所有cityName失败");
    }
    while (sqlite3_step(statment)==SQLITE_ROW) {
        NSString *str=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 0)];
        [arr addObject:str];
    }
    sqlite3_finalize(statment);
    
    if (![self closeDB]) {
        NSLog(@"查询所有cityName时关闭数据库失败");
        return nil;
    }

    return arr;
}

-(NSMutableArray *)selectAllCityInfo{
    NSMutableArray *arr=[NSMutableArray array];
    if (![self openDB]) {
        NSLog(@"查询所有cityInfo时打开数据库失败");
        return nil;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT id,cityName FROM citys"];
    sqlite3_stmt *statment;
    int result=sqlite3_prepare_v2(_dbSqlite, [sqlStr UTF8String], -1, &statment, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"查询所有cityInfo失败");
    }
    while (sqlite3_step(statment)==SQLITE_ROW) {
        int cityId=sqlite3_column_int(statment, 0);
        NSString *cityName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 1)];
        NSArray *array=@[[NSNumber numberWithInt:cityId],cityName];
        [arr addObject:array];
    }
    sqlite3_finalize(statment);
    
    if (![self closeDB]) {
        NSLog(@"查询所有cityInfo时关闭数据库失败");
        return nil;
    }
    
    return arr;
}

-(BOOL)insertCity:(NSString *)cityName{
    if (![self openDB]) {
        NSLog(@"添加新的城市时打开数据库失败");
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_citys (cityName) VALUES ('%@')",cityName];
    
    int result=sqlite3_exec(_dbSqlite, [sqlStr UTF8String], nil, nil, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"添加新的城市失败");
        return NO;
    }
    
    if (![self closeDB]) {
        NSLog(@"添加新的城市时关闭数据库失败");
        return NO;
    }
    
    return YES;
}

//SELECT * FROM citys WHERE cityName LIKE '%b%' OR cityCode LIKE '%bo%'
/**
 *  通过字母或文字查询与之相关的城市信息
 */
-(NSMutableArray *)selectCityInfoByStr:(NSString *)str{
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![self openDB]) {
        NSLog(@"通过字母或文字查询与之相关的城市信息时打开数据库失败");
        return nil;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM citys WHERE cityName LIKE '%%%@%%' OR cityCode LIKE '%%%@%%'",str,str];
    sqlite3_stmt *statment;
    int result=sqlite3_prepare_v2(_dbSqlite, [sqlStr UTF8String], -1, &statment, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"通过字母或文字查询与之相关的城市信息失败");
    }
    while (sqlite3_step(statment)==SQLITE_ROW) {
        City *city=[[City alloc] init];
        city.cityCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 0)];
        city.cityId=sqlite3_column_int(statment, 1);
        city.cityName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 2)];
        [arr addObject:city];
    }
    sqlite3_finalize(statment);
    
    if (![self closeDB]) {
        NSLog(@"通过字母或文字查询与之相关的城市信息时关闭数据库失败");
        return nil;
    }
    
    return arr;
}

@end
