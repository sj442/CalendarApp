//
//  CalendarVC.h
//  CRMStar
//
//  Created by Sunayna Jain on 2/20/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"
#import <EventKit/EventKit.h>
#import "CalendarView.h"


@interface CalendarVC : UIViewController <CKCalendarViewSwipeDelegate>

@property (strong, nonatomic) EKEventStore *localEventStore;
@property (strong, nonatomic) NSArray *events;
@property (strong, nonatomic) CalendarView *calendarView;
@property (strong, nonatomic) NSNumber *displayMode;

@property BOOL fromActivityView;

-(id)initWithDisplayMode:(CKCalendarDisplayMode)mode andDate:(NSDate*)date;

@end
