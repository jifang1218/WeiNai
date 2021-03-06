//
//  EMDBManager.h
//  WeiNai
//
//  Created by Ji Fang on 7/13/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EMDayRecord;
@class EMSettings;

@interface EMDBManager : NSObject

@property (nonatomic, strong, readonly) EMSettings *settings;

// query
- (NSArray *)allDayRecords;
- (EMDayRecord *)dayRecordAt:(NSDateComponents *)day;
- (NSArray *)dayRecordsInMonthAndYear:(NSDateComponents *)monthAndYear;
- (NSArray *)dayRecordsForYear:(NSDateComponents *)year;
- (NSArray *)dayRecordsFrom:(NSDateComponents *)from
                         to:(NSDateComponents *)to;

// insert
- (BOOL)insertDayRecord:(EMDayRecord *)dayRecord;
- (NSInteger)insertDayRecords:(NSArray *)dayRecords;

// delete
- (BOOL)deleteDayRecordAtDay:(NSDateComponents *)day;
- (NSInteger)deleteDayRecordsFrom:(NSDateComponents *)from
                               to:(NSDateComponents *)to;

// modify
- (BOOL)replaceDayRecord:(EMDayRecord *)oldDayRecord
           withDayRecord:(EMDayRecord *)newDayRecord;
- (BOOL)modifyDayRecord:(EMDayRecord *)dayRecord
                   with:(NSString *)params;

- (BOOL)save;

@end
