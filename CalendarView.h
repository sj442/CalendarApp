//
//  CalendarView.h
//  CalendarApp
//
//  Created by Sunayna Jain on 4/21/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarViewModes.h"
#import <EventKit/EventKit.h>

@class CalendarView;

@protocol CalendarViewSwipeDelegate <NSObject>

-(void)newDateToPassBack:(NSDate*)date;

-(void)changeHeaderView;

-(void)displayModeChangedTo:(CKCalendarDisplayMode)mode;

@end

@interface CalendarView : UIView <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) id<CalendarViewSwipeDelegate> swipeDelegate;

@property (nonatomic, assign) CKCalendarDisplayMode displayMode;

@property (nonatomic, strong) EKEventStore *eventStore;

@property (nonatomic, strong) NSArray *events;

@property (nonatomic, strong) NSMutableDictionary *eventsDict;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic,strong) NSDate *indexDate;

@property (nonatomic, strong) NSString *headerTitle;

@property(nonatomic, copy)   NSCalendar  *calendar;          // default is [NSCalendar currentCalendar]. setting nil returns to default

-(void)layoutSubviewsForWeek;

-(void)layoutSubviewForMonth;

-(void)layoutSubviewForDay;

-(void)addMonthSwipeGestureRecognizers;

-(void)addWeekSwipeGestureRecognizers;

@end
