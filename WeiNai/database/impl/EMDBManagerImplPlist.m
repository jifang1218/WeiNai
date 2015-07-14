//
//  EMDBManagerImplPlist.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDBManagerImplPlist.h"
#import "EMDayRecord.h"

#define FILENAME @"db.plist"

@interface EMDBManagerImplPlist() {
    NSMutableDictionary *_dbroot;
    NSMutableArray *_dayRecords;
    NSString *_filename;
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
                            @"day_records":@[]};
        [d writeToFile:_filename
            atomically:YES];
        
    }
    
    // open db.
    NSMutableDictionary *dbroot = [[NSMutableDictionary alloc] initWithContentsOfFile:_filename];
    float dbVer = [[dbroot objectForKey:@"db_ver"] floatValue];
    NSLog(@"%f", dbVer);
    NSArray *dayRecords = [dbroot objectForKey:@"day_records"];
    _dayRecords = [[NSMutableArray alloc] initWithArray:dayRecords];
}

- (void)unLoad {
    [_dayRecords removeAllObjects];
    [_dbroot removeAllObjects];
    _dayRecords = nil;
    _dbroot = nil;
}

- (void)save {
    [_dbroot writeToFile:_filename
              atomically:YES];
}

#pragma mark - query
- (NSArray *)allDayRecords {
    NSArray *ret = nil;
    
    ret = _dayRecords.copy;
    
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
    ret = days.copy;
    
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
    ret = days.copy;
    
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
        if ((record.date.year >= from.year && record.date.year <= to.year) &&
            (record.date.month >= from.month && record.date.month <= to.month) &&
            (record.date.day >= from.day && record.date.day <= to.day)) {
            [days addObject:record];
        }
    }
    
    ret = days.copy;
    
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