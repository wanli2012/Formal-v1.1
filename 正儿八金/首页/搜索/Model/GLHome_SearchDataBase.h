//
//  GLHome_SearchDataBase.h
//  正儿八金
//
//  Created by 龚磊 on 2017/11/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface GLHome_SearchDataBase : NSObject

@property(nonatomic,strong)FMDatabase *dataBase;
//创建表
+(GLHome_SearchDataBase *)greateTableOfFMWithTableName:(NSString *)tableName;
//插入数据
-(void)insertOfFMWithDataArray:(NSArray*)dataArr;
//删除数据
-(void)deleteAllDataOfFMDB;
//查询数据
-(NSArray*)queryAllDataOfFMDB;
//判断表中是否存在数据
-(BOOL)isDataInTheTable;

@end
