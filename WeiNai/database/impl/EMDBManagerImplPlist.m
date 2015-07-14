//
//  EMDBManagerImplPlist.m
//  WeiNai
//
//  Created by Ji Fang on 7/14/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "EMDBManagerImplPlist.h"

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
//    NSDictionary *d = @{@"db_ver":[NSNumber numberWithFloat:0.1],
//                        @"day_records":@[]};
//    [d writeToFile:];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    _filename = [docDir stringByAppendingPathComponent:FILENAME];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filename]) {
        [[NSDictionary dictionary] writeToFile:_filename
                                    atomically:YES];
        
    }
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
    
    return ret;
}

- (EMDayRecord *)dayRecordAt:(NSDateComponents *)day {
    EMDayRecord *ret = nil;
    
    return ret;
}

- (NSArray *)dayRecordsInMonthAndYear:(NSDateComponents *)monthAndYear {
    NSArray *ret = nil;
    
    return ret;
}

- (NSArray *)dayRecordsForYear:(NSDateComponents *)year {
    NSArray *ret = nil;
    
    return ret;
}

- (NSArray *)dayRecordsFrom:(NSDateComponents *)from to:(NSDateComponents *)to {
    NSArray *ret = nil;
    
    return ret;
}

#pragma mark - insert
- (BOOL)insertDayRecord:(EMDayRecord *)dayRecord
               afterDay:(NSDateComponents *)day {
    BOOL ret = NO;
    
    return ret;
}

- (NSInteger)insertDayRecords:(NSArray *)dayRecords
                     afterDay:(NSDateComponents *)day {
    NSInteger ret = -1;
    
    return ret;
}

#pragma mark - delete
- (BOOL)deleteDayRecordAtDay:(NSDateComponents *)day {
    BOOL ret = NO;
    
    return ret;
}

- (NSInteger)deleteDayRecordsFrom:(NSDateComponents *)from
                               to:(NSDateComponents *)to {
    NSInteger ret = -1;
    
    return ret;
}

#pragma mark - modify
- (BOOL)replaceDayRecord:(EMDayRecord *)oldDayRecord
           withDayRecord:(EMDayRecord *)newDayRecord {
    BOOL ret = NO;
    
    return ret;
}

- (BOOL)modifyDayRecord:(EMDayRecord *)dayRecord
                   with:(NSString *)params {
    BOOL ret = NO;
    
    return ret;
}

@end
