//
//  NSCalendar+Components.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/12/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSCalendar+Components.h"

@implementation NSCalendar (Components)

- (NSInteger)weekOfMonthInDate:(NSDate*)date
{
    return [[self components:NSWeekOfMonthCalendarUnit fromDate:date] weekOfMonth];
}


- (NSInteger)weekOfYearInDate:(NSDate*)date
{
    return [[self components:NSWeekOfYearCalendarUnit fromDate:date] weekOfYear];
}

- (NSInteger)weekdayInDate:(NSDate*)date
{
    return [[self components:NSWeekdayCalendarUnit fromDate:date] weekday];
}


- (NSInteger)secondsInDate:(NSDate*)date
{
    return [[self components:NSSecondCalendarUnit fromDate:date] second];
}

- (NSInteger)minutesInDate:(NSDate*)date
{
    return [[self components:NSMinuteCalendarUnit fromDate:date] minute];
}

- (NSInteger)hoursInDate:(NSDate*)date
{
    return [[self components:NSHourCalendarUnit fromDate:date] hour];
}

- (NSInteger)daysInDate:(NSDate*)date
{
    return [[self components:NSDayCalendarUnit fromDate:date] day];
}

- (NSInteger)monthsInDate:(NSDate*)date
{
    return [[self components:NSMonthCalendarUnit fromDate:date] month];
}

- (NSInteger)yearsInDate:(NSDate*)date
{
    return [[self components:NSYearCalendarUnit fromDate:date] year];
}

- (NSInteger)eraInDate:(NSDate*)date
{
    return [[self components:NSEraCalendarUnit fromDate:date] era];
}



@end
