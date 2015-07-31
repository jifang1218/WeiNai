//
//  Toolbox.h
//  WeiNai
//
//  Created by Ji Fang on 7/29/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ToolboxDelegate <NSObject>

@optional

@end

@interface Toolbox : NSObject

@property (nonatomic, weak) id<ToolboxDelegate> delegate;
@property (nonatomic, strong) NSDateComponents *lastPissRecordDate;

- (BOOL)isPissAvailable;
- (NSString *)pissSoundPath;
- (NSURL *)pissSoundURL;

@end
