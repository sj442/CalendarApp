//
//  NSDate+Format.m
//  CRMStar
//
//  Created by Sunayna Jain on 2/25/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "NSDate+Format.h"
#import "NSDate+Description.h"

@implementation NSDate (Format)

+(NSString*)formattedDateFromDate:(NSDate*)date
{
    //get day, month and year components from current Day
    
    NSDate *today = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * todayComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    NSInteger todayYear = [todayComponents year];
    NSInteger todayMonth = [todayComponents month];
    NSInteger todayDay = [todayComponents day];
    
    NSLog(@"today year %ld month %ld day %ld", (long)todayYear, (long)todayMonth, (long)todayDay);
    
    //get year , month and day components from date parameter
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    
    NSLog(@"date year %ld month %ld and day %ld", (long)year, (long)month, (long)day);
    
    if (year==todayYear && month==todayMonth && day==todayDay)
    {
        return @"Today";
    }
    else if (year==todayYear && month==todayMonth && day==todayDay-1)
    {
        return @"Yesterday";
    }
    else if (year==todayYear && month==todayMonth && day==todayDay+1)
    {
        return @"Tomorrow";
        
    } else
    {
        return [self datestringFromDate:date];
    }
}

+(NSString*)datestringFromDate:(NSDate*)date
{
    NSDateFormatter *dateFromatter = [[NSDateFormatter alloc]init];
    [dateFromatter setDateFormat:@"MM/dd"];
    return [dateFromatter stringFromDate:date];
}


+(NSString *)formattedTimeFromDate:(NSDate *)date
{
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"hh:mm a"];

    return [timeFormatter stringFromDate:date];
}

+(NSDate*)calendarStartDateFromDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger startHour = 00;
    NSInteger startMinute =01;
    
    NSDateComponents *startDateComponents = [[NSDateComponents alloc]init];
    
    [startDateComponents setYear:year];
    [startDateComponents setMonth:month];
    [startDateComponents setDay:day];
    [startDateComponents setHour:startHour];
    [startDateComponents setMinute:startMinute];
    
    return [calendar dateFromComponents:startDateComponents];

}

+(NSDate*)calendarEndDateFromDate:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger year = [dateComponents year];
    NSInteger month = [dateComponents month];
    NSInteger day = [dateComponents day];
    NSInteger endHour = 23;
    NSInteger endMinute = 59;
    
    NSDateComponents *endDateComponents = [[NSDateComponents alloc]init];
    [endDateComponents setYear:year];
    [endDateComponents setMonth:month];
    [endDateComponents setDay:day];
    [endDateComponents setHour:endHour];
    [endDateComponents setMinute:endMinute];
    
    return [calendar dateFromComponents:endDateComponents];
}

+(NSDate*)createDateFromComponentsYear:(NSInteger)year andMonth:(NSInteger)month andDay:(NSInteger)day
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];

    return [calendar dateFromComponents:components];
}

+(NSString*)checkWeekOfDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger todayWeek = [calendar weekOfMonthInDate:[NSDate date]];
    
    NSInteger dateWeek =[calendar weekOfMonthInDate:date];
    
    if (dateWeek==todayWeek){
        
        return @"This Week";
    }
    else if (dateWeek==todayWeek+1)
    {
        return @"Next Week";
    }
    else
    {
        return @"";
    }
}

+(NSString*)checkMonthOfDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger todayMonth = [calendar monthsInDate:[NSDate date]];
    
    NSInteger dateMonth = [calendar monthsInDate:date];
    
    if (todayMonth==dateMonth)
    {
        return @"This Month";
    }
    else if (dateMonth==todayMonth+1)
    {
        return @"Next Month";
    }
    
    else return @"";
}

+(NSString*)checkDayOfDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger todayDay = [calendar daysInDate:[NSDate date]];
    
    NSInteger dateDay = [calendar daysInDate:date];
    
    if (todayDay==dateDay)
    {
        return @"Today";
    }
    else if (dateDay ==todayDay+1)
    {
        return @"Tomorrow";
    }
    else
    {
        return @"";
    }
}


+(NSArray*)checkMonthWeekAndDayOfDate:(NSDate*)date
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:3];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger todayMonth = [calendar monthsInDate:[NSDate date]];
    
    NSInteger dateMonth = [calendar monthsInDate:date];
    
    if (todayMonth==dateMonth)
    {
        [array addObject:@"This Month"];
        
        NSInteger todayWeek = [calendar weekOfMonthInDate:[NSDate date]];
        
        NSInteger dateWeek = [calendar weekOfMonthInDate:date];
        
        if (todayWeek==dateWeek)
        {
            [array addObject:@"This Week"];
            
            NSInteger todayDay = [calendar daysInDate:[NSDate date]];
            
            NSInteger dateDay = [calendar daysInDate:date];
            
            if (todayDay==dateDay)
            {
                [array addObject:@"Today"];
            }
            else if (todayDay ==dateDay+1)
            {
                [array addObject:@"Tomorrow"];
            }
            else
            {
                [array addObject:@""];
            }
        }
        else if (todayWeek == dateWeek+1)
        {
            [array addObject:@"Next Week"];
        }
        else
        {
            [array addObjectsFromArray:@[@"", @""]];
        }
        
        return array;
        
    } else if (todayMonth==dateMonth+1)
    {
        [array addObject:@"Next Month"];
        
        [array addObjectsFromArray:@[@"", @""]];
        
        return array;
        
    } else
    {
        [array addObjectsFromArray:@[@"", @"", @""]];
        
        return array;
    }
}

+ (NSString*)getOrdinalSuffixForDate: (NSDate*)date forCalendar:(NSCalendar *)calendar{
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitDay fromDate:date];
    
    NSInteger day= [components day];
    
    NSString *monthName = [date monthNameOnCalendar:[NSCalendar currentCalendar]];
    
    NSInteger year = [components year];
    
	NSArray *suffixLookup = [NSArray arrayWithObjects:@"th",@"st",@"nd",@"rd",@"th",@"th",@"th",@"th",@"th",@"th", nil];
    
	if (day % 100 >= 11 && day % 100 <= 13) {
		return [NSString stringWithFormat:@"%ld%@ %@ %ld", (long)day, @"th", monthName, (long)year];
	}
    
	return [NSString stringWithFormat:@"%ld%@ %@ %ld ",(long)day, [suffixLookup objectAtIndex:(day % 10)], monthName, (long)year];
}

+(NSString*)getWeekdayfromDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"cccc"];
    
    return [formatter stringFromDate:date];
}

@end
