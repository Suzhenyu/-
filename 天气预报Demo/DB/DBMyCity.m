//
//  DBMyCity.m
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "DBMyCity.h"
#import "MyCity.h"

static DBMyCity *singleInstance=nil;

@interface DBMyCity ()
{
    sqlite3 *_dbSqlite;
}

@end

@implementation DBMyCity

+(DBMyCity *)shareMyCity{
    if (singleInstance==nil) {
        singleInstance=[[DBMyCity alloc] init];
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


-(NSMutableArray *)selectMyCityInfo{
    NSMutableArray *arr=[NSMutableArray array];
    
    if (![self openDB]) {
        NSLog(@"返回tb_mycitys中的所有数据时打开数据库失败");
        return nil;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT * FROM tb_mycitys"];
    sqlite3_stmt *statment;
    int result=sqlite3_prepare_v2(_dbSqlite, [sqlStr UTF8String], -1, &statment, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"返回tb_mycitys中的所有数据失败");
        return nil;
    }
    while (sqlite3_step(statment)==SQLITE_ROW) {
        MyCity *myCity=[[MyCity alloc] init];
        myCity.cityName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 0)];
        myCity.cityWeatherImg=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 1)];
        myCity.cityTemperature=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 2)];
        myCity.cityPM2d5=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 3)];
        myCity.cityPM2d5Level=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statment, 4)];
        [arr addObject:myCity];
    }
    sqlite3_finalize(statment);
    
    if (![self closeDB]) {
        NSLog(@"返回tb_mycitys中的所有数据时关闭数据库失败");
        return nil;
    }
    
    return arr;
}

/**
 *  更新数据
 */
-(BOOL)updateMyCityInfo:(MyCity *)city{
    if (![self openDB]) {
        NSLog(@"更新我的城市信息时打开数据库失败");
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"UPDATE tb_mycitys SET cityWeatherImg='%@',cityTemperature ='%@',cityPM2d5='%@',cityPM2d5Level='%@'  WHERE  cityName='%@'",city.cityWeatherImg,city.cityTemperature,city.cityPM2d5,city.cityPM2d5Level,city.cityName];
    int result=sqlite3_exec(_dbSqlite, [sqlStr UTF8String], nil, nil, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"更新我的城市信息失败");
        return NO;
    }
    
    if (![self closeDB]) {
        NSLog(@"更新我的城市信息关闭数据库失败");
        return NO;
    }
    
    return YES;
}

//INSERT INTO tb_mycitys (cityName,cityWeatherImg,cityTemperature,cityPM2d5,cityPM2d5Level) VALUES ('上海市','22','33','33','3')
/**
 *  插入数据
 */
-(BOOL)insertMyCityInfo:(MyCity *)city{
    if (![self openDB]) {
        NSLog(@"新建我的城市信息时打开数据库失败");
        return NO;
    }
    
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_mycitys (cityName,cityWeatherImg,cityTemperature,cityPM2d5,cityPM2d5Level) VALUES ('%@','%@','%@','%@','%@')",city.cityName,city.cityWeatherImg,city.cityTemperature,city.cityPM2d5,city.cityPM2d5Level];
    int result=sqlite3_exec(_dbSqlite, [sqlStr UTF8String], nil, nil, nil);
    if (result!=SQLITE_OK) {
        NSLog(@"新建我的城市信息失败");
        return NO;
    }
    
    if (![self closeDB]) {
        NSLog(@"新建我的城市信息关闭数据库失败");
        return NO;
    }
    
    return YES;
}

@end
