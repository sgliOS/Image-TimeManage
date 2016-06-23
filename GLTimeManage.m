//
//  GLTimeManage.m
//  pinLuCarService
//
//  Created by sgl on 16/6/8.
//  Copyright © 2016年 PinLu. All rights reserved.
//

#import "GLTimeManage.h"

@interface GLTimeManage (){
    NSPredicate *_zz_dateFormatter_default;
}
@property(nonatomic,strong)NSPredicate *_zz_dateFormatter_default;
@end

@implementation GLTimeManage
@synthesize dateFormatter_default,dateFormatter_onlyDate,dateFormatter_onlyDate_simple,dateFormatter_onlyTime,dateFormatter_onlyTime_simple,dateFormatter_simple_LR,dateFormatter_simple_R,dateFormatter_onlyMonth,dateFormatter_simple_LR2;
@synthesize _zz_dateFormatter_default;

__strong static GLTimeManage * _sharedObject = nil;

+(GLTimeManage *)ShareManage
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedObject = [[GLTimeManage alloc] init];
        _sharedObject._zz_dateFormatter_default = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",Regex_DateFormatter_Default];
        _sharedObject.dateFormatter_default = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_default setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        _sharedObject.dateFormatter_simple_R = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_simple_R setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        _sharedObject.dateFormatter_simple_LR = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_simple_LR setDateFormat:@"MM-dd HH:mm"];
        
        _sharedObject.dateFormatter_onlyDate = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_onlyDate setDateFormat:@"yyyy-MM-dd"];
        
        _sharedObject.dateFormatter_onlyDate_simple = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_onlyDate_simple setDateFormat:@"yyyy-MM"];
        
        _sharedObject.dateFormatter_onlyMonth = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_onlyMonth setDateFormat:@"MM-dd"];
        
        _sharedObject.dateFormatter_onlyTime = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_onlyTime setDateFormat:@"HH:mm:ss"];
        
        _sharedObject.dateFormatter_onlyTime_simple = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_onlyTime_simple setDateFormat:@"HH:mm"];
        
        _sharedObject.dateFormatter_simple_LR2 = [[NSDateFormatter alloc] init];
        [_sharedObject.dateFormatter_simple_LR2 setDateFormat:@"MM月dd日HH:mm"];
    });
    if (nil == _sharedObject) {
        WarningLog(@"MTHKTimeManage Instance == nil");
    }
    return _sharedObject;
}
-(double)timeDoubleValueCurrent
{
    NSDate *dat = [NSDate date];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    return timeInterval;
}
-(long long)timeLongLongValueCurrent
{
    //距离1970的毫秒
    NSDate *dat = [NSDate date];
    NSTimeInterval timeInterval = [dat timeIntervalSince1970];
    return timeInterval*1000;
}
-(NSString *)timeStringValueCurrentWithReturnType:(int)dateFormatterType
{
    NSString *_timeStr = @"";
    if (dateFormatterType == K_Time_dateFormatter_default) {
        _timeStr = [dateFormatter_default stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMMddHHmm) {
        _timeStr = [dateFormatter_simple_R stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm) {
        _timeStr = [dateFormatter_simple_LR stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Date) {
        _timeStr = [dateFormatter_onlyDate stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMM) {
        _timeStr = [dateFormatter_onlyDate_simple stringFromDate:[NSDate date]];
    }
    else if(dateFormatterType == K_Time_dateFormatter_MMdd) {
        _timeStr = [dateFormatter_onlyMonth stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Time) {
        _timeStr = [dateFormatter_onlyTime stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_HHmm) {
        _timeStr = [dateFormatter_onlyTime_simple stringFromDate:[NSDate date]];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm2) {
        _timeStr = [dateFormatter_simple_LR2 stringFromDate:[NSDate date]];
    }
    else
    {
        WarningLog(@"unknown dateFormatter type");
    }
    return _timeStr;
}
-(double)timeDoubleValueFromString:(NSString*)dateStr
{
    if ([_zz_dateFormatter_default evaluateWithObject:dateStr]) {
        NSDate* date = [dateFormatter_default dateFromString:dateStr];
        double timeSp =  [date timeIntervalSince1970];
        return timeSp;
    }
    else{
        WarningLog(@"wrong insert dateFormatter");
        return 0;
    }
}
-(NSString*)timeStringValueFromDouble:(double)seconds returnType:(int)dateFormatterType
{
    NSString *_timeStr = @"";
    NSDate *timeDate=[NSDate dateWithTimeIntervalSince1970:seconds];
    if (dateFormatterType == K_Time_dateFormatter_default) {
        _timeStr = [dateFormatter_default stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMMddHHmm) {
        _timeStr = [dateFormatter_simple_R stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm) {
        _timeStr = [dateFormatter_simple_LR stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Date) {
        _timeStr = [dateFormatter_onlyDate stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMM) {
        _timeStr = [dateFormatter_onlyDate_simple stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMdd) {
        _timeStr = [dateFormatter_onlyMonth stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Time) {
        _timeStr = [dateFormatter_onlyTime stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_HHmm) {
        _timeStr = [dateFormatter_onlyTime_simple stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm2) {
        _timeStr = [dateFormatter_simple_LR2 stringFromDate:timeDate];
    }
    else
    {
        WarningLog(@"unknown dateFormatter type");
    }
    return _timeStr;
}
-(NSString*)timeStringValueFromDate:(NSDate*)timeDate returnType:(int)dateFormatterType
{
    NSString *_timeStr = @"";
    if (dateFormatterType == K_Time_dateFormatter_default) {
        _timeStr = [dateFormatter_default stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMMddHHmm) {
        _timeStr = [dateFormatter_simple_R stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm) {
        _timeStr = [dateFormatter_simple_LR stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Date) {
        _timeStr = [dateFormatter_onlyDate stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_yyyyMM) {
        _timeStr = [dateFormatter_onlyDate_simple stringFromDate:timeDate];
    }
    else if(dateFormatterType == K_Time_dateFormatter_MMdd) {
        _timeStr = [dateFormatter_onlyMonth stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_Time) {
        _timeStr = [dateFormatter_onlyTime stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_HHmm) {
        _timeStr = [dateFormatter_onlyTime_simple stringFromDate:timeDate];
    }
    else if (dateFormatterType == K_Time_dateFormatter_MMddHHmm2) {
        _timeStr = [dateFormatter_simple_LR2 stringFromDate:timeDate];
    }
    else{
        WarningLog(@"unknown dateFormatter type");
    }
    return _timeStr;
}
-(NSString*)dateStringFromBeginTime:(double)beginValue EndTime:(double)endValue
{
    double value = endValue - beginValue;
    if (value >= 0 ) {
        NSInteger ti = (NSInteger)value;
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600);
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    else {
        return @"00:00:00";
    }
}
-(NSString*)getTimeFormatMinuteAndSecond:(int)time
{
    int min = 0;
    int sec = 0;
    if(time){
        min=time/60;
        sec=time-min*60;
        return [NSString stringWithFormat:@"%d分%d秒",min,sec];
    }
    return [NSString stringWithFormat:@"%d",time ];
}
/*
 * @param ss
 * return mm:ss
 */
-(NSString*)dateStringFromSeconds:(int)seconds
{
    if (seconds >= 0 ) {
        NSInteger ti = (NSInteger)seconds;
        NSInteger second = ti % 60;
        NSInteger minute = (ti / 60) % 60;
        NSInteger hour = (ti / 3600);
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hour, (long)minute, (long)second];
    }
    else
        return @"00:00:00";
    
}
-(NSDate*)dateObjectFromInteval:(long long)interval
{
    if (interval > 0 ) {
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
        //        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        //        NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
        //        NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
        return confromTimesp;
    }
    else
        return nil;
}
@end
