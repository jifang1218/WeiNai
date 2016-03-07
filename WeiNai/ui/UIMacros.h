//
//  UIMacros.h
//  WeiNai
//
//  Created by Ji Fang on 7/15/15.
//  Copyright (c) 2015 Ji Fang. All rights reserved.
//

#ifndef WeiNai_UIMacros_h
#define WeiNai_UIMacros_h

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD_RUNTIME (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

typedef enum _EMActivityType {
    ActivityType_PowderMilk = 0,
    ActivityType_PersonMilk,
    ActivityType_Piss,
    ActivityType_Excrement,
    ActivityType_Sleep,
    ActivityType_NumberOfActivityTypes
}EMActivityType;

typedef enum _EMMilkType {
    MilkType_BreastMilk = 0,
    MilkType_PowderMilk
}EMMilkType;

typedef enum _EMSleepQuality {
    SleepQuality_Medium = 0,
    SleepQuality_Shallow,
    SleepQuality_Deep
}EMSleepQuality;

typedef enum _EMPissColor {
    PissColor_White = 0,
    PissColor_Yellow
}EMPissColor;

typedef enum _EMExcrementQuality {
    ExcrementQualityGood = 0,
    ExcrementQualityBad
} EMExcrementQuality;

typedef enum _EMDayRecordsPeriod {
    DayRecordsPeriod_Week = 0,
    DayRecordsPeriod_3Weeks,
    DayRecordsPeriod_Month,
    DayRecordsPeriod_3Month
} EMDayRecordsPeriod;

typedef enum _EMChartStyle {
    ChartStyle_Line = 0,
    ChartStyle_Bar
} EMChartStyle;

#endif
