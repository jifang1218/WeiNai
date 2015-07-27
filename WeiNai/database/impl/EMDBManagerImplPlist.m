//
//  EMDBManagerImplPlist.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDBManagerImplPlist.h"
#import "EMDayRecord+Dict.h"
#import "EMPiss+Dict.h"
#import "EMBreastMilk+Dict.h"
#import "EMPowderMilk+Dict.h"
#import "EMExcrement+Dict.h"
#import "EMSleep+Dict.h"
#import "NSDateComponents+Dict.h"

#define FILENAME @"db.plist"
#define DB_VER @"db_ver"
#define SETTINGS @"settings"
#define DAY_RECORDS @"day_records"

@interface EMDBManagerImplPlist() {
    NSMutableArray *_dayRecords; // EMDayRecord array
    NSMutableDictionary *_settings;
    NSString *_filename;
    float _dbVer;
}

@end

@implementation EMDBManagerImplPlist

- (id)init {
    if (self=[super init]) {
        [self load];
    }
    
    return self;
}

- (void)dealloc {
    [self unLoad];
}

- (void)load {
    // get db file in document directory.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    _filename = [docDir stringByAppendingPathComponent:FILENAME];
    
    // write default db.
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filename]) {
        NSDictionary *d = @{@"db_ver":[NSNumber numberWithFloat:0.1],
                            @"settings":[NSDictionary dictionary],
                            @"day_records":@[]};
        BOOL result = NO;
        result = [d writeToFile:_filename
                     atomically:YES];
        
    }
    
    // open db.
    NSDictionary *dbroot = [[NSDictionary alloc] initWithContentsOfFile:_filename];
    _dbVer = [[dbroot objectForKey:@"db_ver"] floatValue];
    _settings = [dbroot objectForKey:@"settings"];
    
    // handle objects
    NSArray *dayRecordDicts = [dbroot objectForKey:@"day_records"];
    NSMutableArray *dayRecords = [[NSMutableArray alloc] initWithCapacity:dayRecordDicts.count];
    for (NSDictionary *dayRecordDict in dayRecordDicts) {
        EMDayRecord *dayRecord = [[EMDayRecord alloc] initWithDict:dayRecordDict];
        [dayRecords addObject:dayRecord];
    }
    _dayRecords = dayRecords;
}

- (void)unLoad {
}

- (BOOL)save {
    BOOL ret = NO;
    
    NSMutableArray *dayRecordDicts = [[NSMutableArray alloc] initWithCapacity:_dayRecords.count];
    for (EMDayRecord *dayRecord in _dayRecords) {
        NSDictionary *dayRecordDict = [dayRecord toDict];
        [dayRecordDicts addObject:dayRecordDict];
    }
    NSDictionary *dict = @{DAY_RECORDS:dayRecordDicts,
                           SETTINGS:_settings,
                           DB_VER:[NSNumber numberWithFloat:_dbVer]};
    
    ret = [dict writeToFile:_filename
                    atomically:YES];
    
    return ret;
}

#pragma mark - query
- (NSArray *)allDayRecords {
    NSArray *ret = nil;
    
    ret = _dayRecords;
    
    return ret;
}

- (EMDayRecord *)dayRecordAt:(NSDateComponents *)day {
    EMDayRecord *ret = nil;
    
    // validation
    if (!day.year || !day.month || !day.day) {
        return ret;
    }
    
    for (EMDayRecord *record in _dayRecords) {
        if (record.date.year == day.year &&
            record.date.month == day.month &&
            record.date.day == day.day) {
            ret = record;
            break;
        }
    }
    
    return ret;
}

- (NSArray *)dayRecordsInMonthAndYear:(NSDateComponents *)monthAndYear {
    NSArray *ret = nil;
    
    // validation
    if (!monthAndYear.year || !monthAndYear.month) {
        return ret;
    }
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (EMDayRecord *record in _dayRecords) {
        if (record.date.year == monthAndYear.year &&
            record.date.month == monthAndYear.month) {
            [days addObject:record];
        }
    }
    ret = days;
    
    return ret;
}

- (NSArray *)dayRecordsForYear:(NSDateComponents *)year {
    NSArray *ret = nil;
    
    // validation
    if (!year.year) {
        return ret;
    }
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (EMDayRecord *record in _dayRecords) {
        if (record.date.year == year.year) {
            [days addObject:record];
        }
    }
    ret = days;
    
    return ret;
}

- (NSArray *)dayRecordsFrom:(NSDateComponents *)from
                         to:(NSDateComponents *)to {
    NSArray *ret = nil;
    
    // validation
    if (!from.year || !from.month || !from.day ||
        !to.year || !to.month || !to.day) {
        return ret;
    }
    
    NSMutableArray *days = [[NSMutableArray alloc] init];
    for (EMDayRecord *record in _dayRecords) {
        BOOL isInRange = NO;
        // 1. year is in range
        if ((record.date.year >= from.year) && (record.date.year <= to.year)) {
            if (from.year != to.year) {
                isInRange = YES;
            } else {
                // 2. month is in range
                if ((record.date.month >= from.month) && (record.date.month <= to.month)) {
                    if (from.month != to.month) {
                        isInRange = YES;
                    } else {
                        // 3. day is in range
                        if ((record.date.day >= from.day) && (record.date.day <= to.day)) {
                            isInRange = YES;
                        }
                    }
                }
            }
        }
        
        if (isInRange) {
            [days addObject:record];
        }
    }
    
    ret = days;
    
    return ret;
}

#pragma mark - insert
- (BOOL)insertDayRecord:(EMDayRecord *)dayRecord {
    BOOL ret = NO;
    
    // validation
    if (!dayRecord.date.year || !dayRecord.date.month || !dayRecord.date.day) {
        return ret;
    }
    
    [_dayRecords addObject:dayRecord];
    ret = YES;
    
    return ret;
}

- (NSInteger)insertDayRecords:(NSArray *)dayRecords {
    NSInteger ret = -1;
    
    // validation
    if (!dayRecords) {
        return ret;
    }
    
    NSMutableArray *validRecords = [[NSMutableArray alloc] initWithCapacity:dayRecords.count];
    for (EMDayRecord *dayRecord in dayRecords) {
        if (!dayRecord.date.year || !dayRecord.date.month || !dayRecord.date.day) {
        } else {
            [validRecords addObject:dayRecord];
        }
    }
    
    [_dayRecords addObjectsFromArray:validRecords];
    ret = validRecords.count;
    
    return ret;
}

#pragma mark - delete
- (BOOL)deleteDayRecordAtDay:(NSDateComponents *)day {
    BOOL ret = NO;
    
    if (!day.year || !day.month || !day.day) {
        return ret;
    }
    
    EMDayRecord *record = [self dayRecordAt:day];
    if (record) {
        [_dayRecords removeObject:record];
        ret = YES;
    }
    
    return ret;
}

- (NSInteger)deleteDayRecordsFrom:(NSDateComponents *)from
                               to:(NSDateComponents *)to {
    NSInteger ret = -1;
    
    // validation
    if (!from.year || !from.month || !from.day ||
        !to.year || !to.month || !to.day) {
        return ret;
    }
    
    NSArray *beDeletedRecords = [self dayRecordsFrom:from
                                                  to:to];
    [_dayRecords removeObjectsInArray:beDeletedRecords];
    ret = beDeletedRecords.count;
    
    return ret;
}

#pragma mark - modify
- (BOOL)replaceDayRecord:(EMDayRecord *)oldDayRecord
           withDayRecord:(EMDayRecord *)newDayRecord {
    BOOL ret = NO;
    
    // validation
    if (!oldDayRecord || !newDayRecord) {
        return ret;
    }
    
    EMDayRecord *record = [self dayRecordAt:oldDayRecord.date];
    if (record) {
        // todo
        // do assignment, oldDayRecord = newDayRecord
        ret = YES;
    }
    
    return ret;
}

- (BOOL)modifyDayRecord:(EMDayRecord *)dayRecord
                   with:(NSString *)params {
    BOOL ret = NO;
    
    // validation
    if (!dayRecord) {
        return ret;
    }
    
    EMDayRecord *record = [self dayRecordAt:dayRecord.date];
    if (record) {
        // todo
        // do assignment, oldDayRecord = newDayRecord
        ret = YES;
    }
    
    return ret;
}

@end
