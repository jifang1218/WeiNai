//
//  EMDBManager.m
//  WeiNai
//
//  Created by Ji Fang on 7/13/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDBManager.h"
#import "IDBManagerImpl.h"

#import "EMDBManagerImplPlist.h"

static EMDBManager *_sharedInstance = nil;

@interface EMDBManager () {
    id<IDBManagerImpl> _dbmanImpl;
}

@end

@implementation EMDBManager

+ (EMDBManager *)sharedInstance {
    if (_sharedInstance == nil) {
        @synchronized(self) {
            _sharedInstance = [[EMDBManager alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init {
    if (self=[super init]) {
        _dbmanImpl = [[EMDBManagerImplPlist alloc] init];
    }
    
    return self;
}

- (void)load {
    [_dbmanImpl load];
}

- (void)unLoad {
    [_dbmanImpl unLoad];
}

- (void)save {
    [_dbmanImpl save];
}

#pragma mark - query
- (NSArray *)allDayRecords {
    NSArray *ret = nil;
    
    ret = [_dbmanImpl allDayRecords];
    
    return ret;
}

- (EMDayRecord *)dayRecordAt:(NSDateComponents *)day {
    EMDayRecord *ret = nil;
    
    ret = [_dbmanImpl dayRecordAt:day];
    
    return ret;
}

- (NSArray *)dayRecordsInMonthAndYear:(NSDateComponents *)monthAndYear {
    NSArray *ret = nil;
    
    ret = [_dbmanImpl dayRecordsInMonthAndYear:monthAndYear];
    
    return ret;
}

- (NSArray *)dayRecordsForYear:(NSDateComponents *)year {
    NSArray *ret = nil;
    
    ret = [_dbmanImpl dayRecordsForYear:year];
    
    return ret;
}

- (NSArray *)dayRecordsFrom:(NSDateComponents *)from to:(NSDateComponents *)to {
    NSArray *ret = nil;
    
    ret = [_dbmanImpl dayRecordsFrom:from to:to];
    
    return ret;
}

#pragma mark - insert
- (BOOL)insertDayRecord:(EMDayRecord *)dayRecord {
    BOOL ret = NO;
    
    ret = [_dbmanImpl insertDayRecord:dayRecord];
    
    return ret;
}

- (NSInteger)insertDayRecords:(NSArray *)dayRecords {
    NSInteger ret = -1;
    
    ret = [_dbmanImpl insertDayRecords:dayRecords];
    
    return ret;
}

#pragma mark - delete
- (BOOL)deleteDayRecordAtDay:(NSDateComponents *)day {
    BOOL ret = NO;
    
    ret = [_dbmanImpl deleteDayRecordAtDay:day];
    
    return ret;
}

- (NSInteger)deleteDayRecordsFrom:(NSDateComponents *)from
                               to:(NSDateComponents *)to {
    NSInteger ret = -1;
    
    ret = [_dbmanImpl deleteDayRecordsFrom:from
                                    to:to];
    
    return ret;
}

#pragma mark - modify
- (BOOL)replaceDayRecord:(EMDayRecord *)oldDayRecord
           withDayRecord:(EMDayRecord *)newDayRecord {
    BOOL ret = NO;
    
    ret = [_dbmanImpl replaceDayRecord:oldDayRecord
                     withDayRecord:newDayRecord];
    
    return ret;
}

- (BOOL)modifyDayRecord:(EMDayRecord *)dayRecord
                   with:(NSString *)params {
    BOOL ret = NO;
    
    ret = [_dbmanImpl modifyDayRecord:dayRecord
                             with:params];
    
    return ret;
}

@end
