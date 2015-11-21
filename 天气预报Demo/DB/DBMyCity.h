//
//  DBMyCity.h
//  天气预报Demo
//
//  Created by apple on 15/11/21.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class MyCity;

@interface DBMyCity : NSObject

+(DBMyCity *)shareMyCity;
/**
 *  返回tb_mycitys中的所有数据
 */
-(NSMutableArray *)selectMyCityInfo;
/**
 *  更新数据
 */
-(BOOL)updateMyCityInfo:(MyCity *)city;
/**
 *  插入数据
 */
-(BOOL)insertMyCityInfo:(MyCity *)city;

@end
