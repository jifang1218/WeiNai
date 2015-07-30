//
//  Toolbox.m
//  WeiNai
//
//  Created by Ji Fang on 7/29/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import "Toolbox.h"

static NSString *kPissFile = @"piss.wav";

@interface Toolbox () {
}

@end

@implementation Toolbox

@synthesize delegate = _delegate;

- (NSString *)pissSoundPath {
    NSString *ret = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    ret = [docDir stringByAppendingPathComponent:kPissFile];
    
    return ret;
}
- (NSURL *)pissSoundURL {
    NSURL *ret = nil;
    
    NSString *path = [self pissSoundPath];
    ret = [NSURL URLWithString:path];
    
    return ret;
}

- (BOOL)isPissAvailable {
    BOOL ret = NO;
    
    NSString *piss = [self pissSoundPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:piss]) {
        ret = YES;
    }
    
    return ret;
}

- (NSDateComponents *)lastPissRecordDate {
    NSDateComponents *ret = nil;
    
    return ret;
}

@end
