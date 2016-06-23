//
//  GLTimeManage.h
//  pinLuCarService
//
//  Created by sgl on 16/6/8.
//  Copyright © 2016年 PinLu. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////dateFormatter////////////
#define K_Time_dateFormatter_default            1    /////yyyy-MM-dd HH:mm:ss
#define K_Time_dateFormatter_yyyyMMddHHmm       2    /////yyyy-MM-dd HH:mm
#define K_Time_dateFormatter_MMddHHmm           3    /////MM-dd HH:mm
#define K_Time_dateFormatter_Date               4    /////yyyy-MM-dd
#define K_Time_dateFormatter_yyyyMM             5    /////yyyy-MM
#define K_Time_dateFormatter_MMdd               6    /////MM-dd
#define K_Time_dateFormatter_Time               7    /////HH:mm:ss
#define K_Time_dateFormatter_HHmm               8    /////HH:mm
#define K_Time_dateFormatter_MMddHHmm2          9   /////MM月dd日HH:mm

//////////////////////////////////
#define K_Time_SecondsForOneDay                 60*60*60

//正则
#define Regex_DateFormatter_Default	[NSString stringWithFormat:@"%@",@"^\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}$"]

@interface GLTimeManage : NSObject
@property (nonatomic,strong)NSDateFormatter *dateFormatter_default;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_simple_R;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_simple_LR;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_onlyDate;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_onlyDate_simple;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_onlyMonth;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_onlyTime;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_onlyTime_simple;
@property (nonatomic,strong)NSDateFormatter *dateFormatter_simple_LR2;
/**
 *  实例
 */
+(GLTimeManage *)ShareManage;
//获取当前时间
-(double)timeDoubleValueCurrent;            //距离1970的秒数
-(long long)timeLongLongValueCurrent;       //距离1970的毫秒数
-(NSString *)timeStringValueCurrentWithReturnType:(int)dateFormatterType;
//时间格式转换
-(double)timeDoubleValueFromString:(NSString*)dateStr;//参数：yyyy-MM-dd HH:mm:ss
-(NSString*)timeStringValueFromDouble:(double)seconds returnType:(int)dateFormatterType;//参数：距离1970的秒数
-(NSString*)timeStringValueFromDate:(NSDate*)aDate returnType:(int)dateFormatterType;
-(NSString*)dateStringFromSeconds:(int)seconds;//181s --> 00:03:01
-(NSString*)dateStringFromBeginTime:(double)beginValue EndTime:(double)endValue;
-(NSString*)getTimeFormatMinuteAndSecond:(int)time;//参数：ss  －> mm:ss
-(NSDate*)dateObjectFromInteval:(long long)inteval;
//计算时间差
@end

