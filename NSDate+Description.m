//
//  NSDate+Description.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "NSDate+Description.h"

@implementation NSDate (Description)

- (NSString *)description
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    return [formatter stringFromDate:self];
}

- (NSString *)dayNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"ccc"];
    return [[f stringFromDate:self] substringToIndex:1];
}

- (NSString *)monthNameOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMMM"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMMM yyyy"];
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMM yyyy"];
    return [f stringFromDate:self];
}

- (NSString *)monthAbbreviationOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMM"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMMM d"];
    return [f stringFromDate:self];
}

- (NSString *)dayOfMonthOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"d"];
    return [f stringFromDate:self];
}

- (NSString *)monthAndDayAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"MMM d yyyy"];
    return [f stringFromDate:self];
}


- (NSString *)dayOfMonthAndYearOnCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *f = [NSDateFormatter new];
    [f setCalendar:calendar];
    [f setDateFormat:@"d yyyy"];
    return [f stringFromDate:self];
}

-(NSString*)formattedString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MM/dd/yy HH:mm a"];
        
    return [dateFormatter stringFromDate:self];
}

+(BOOL)checkIfFirstDate:(NSDate*)firstDate isSmallerThanSecondDate:(NSDate*)secondDate{
    
    NSTimeInterval first = [firstDate timeIntervalSince1970];
    
    NSLog(@"first time interval %f", first);
    
    NSTimeInterval second = [secondDate timeIntervalSince1970];
    
    NSLog(@"second time interval %f", second);
    
    int difference = second-first;
    
    if (difference>0) {
        
        return YES;
    }
    
    else {
        
        return NO;
    }
}

+ (NSString*)getOrdinalSuffix: (NSDate*)date forCalendar:(NSCalendar *)calendar{
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];

    NSInteger day= [components day];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"cccc"];
    
    NSString *weekday = [formatter stringFromDate:date];
    
	NSArray *suffixLookup = [NSArray arrayWithObjects:@"th",@"st",@"nd",@"rd",@"th",@"th",@"th",@"th",@"th",@"th", nil];
    
	if (day % 100 >= 11 && day % 100 <= 13) {
		return [NSString stringWithFormat:@"%@, the %ld%@", weekday, (long)day, @"th"];
	}
    
	return [NSString stringWithFormat:@"%@, the %ld%@", weekday, (long)day, [suffixLookup objectAtIndex:(day % 10)]];
}



@end
