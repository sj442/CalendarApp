//
//  NewEventViewController.h
//  CRMStar
//
//  Created by Sunayna Jain on 2/11/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKit/EKEvent.h>
#import "AppDelegate.h"

@interface NewEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>

{
        NSInteger dateSection;
        
        NSInteger startTimeIndex;
        
        NSInteger endTimeIndex;
        
        NSInteger rows;
}

@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;

@property (strong, nonatomic) EKEvent *event;

@property (strong, nonatomic) EKEventStore *localEventStore;

@property (strong, nonatomic) NSDate *startDate;

@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSString *notes;

@property (strong, nonatomic) NSCalendar *calendar;

@property BOOL eventSelected;

-(id)initWithEventViewMode;


@end
