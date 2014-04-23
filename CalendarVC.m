//
//  CalendarVC.m
//  CRMStar
//
//  Created by Sunayna Jain on 2/20/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "CalendarVC.h"
#import "AppDelegate.h"
#import "UIBarButtonItem+EH.h"
#import "UIColor+EH.h"
#import "NSDate+Format.h"
#import "NewEventViewController.h"
#import "NSDate+Description.h"

@interface CalendarVC ()

@end

@implementation CalendarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.calendarView = [CalendarView new];
    }
    return self;
}

-(id)initWithDisplayMode:(CKCalendarDisplayMode)mode andDate:(NSDate*)date
{
    self = [super init];
    
    if(self)
    {
    self.calendarView = [CalendarView new];
    self.calendarView.displayMode = mode;
    self.calendarView.date = date;
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self setupEventStore];
    
    if (!self.fromActivityView)
        
    {
    
    [self addPlusButton];
        
    }
    
    [self setMenuBarButton];
    
   // [((MMDrawerController*)self.navigationController.parentViewController) setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeBezelPanningCenterView];
    
   // [((MMDrawerController*)self.navigationController.parentViewController) setCloseDrawerGestureModeMask:MMCloseDrawerGestureModePanningCenterView];
    
   // [((MMDrawerController*)self.navigationController.parentViewController) setMaximumRightDrawerWidth:230];
    
    CGFloat height = 44 + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.calendarView.frame = CGRectMake(0,height, self.view.frame.size.width, self.view.frame.size.height-height-40);
    //Do any additional setup after loading the view.
        
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0,self.view.frame.size.height-40, self.view.frame.size.width, 40);
    toolbar.opaque = NO;
    toolbar.tintColor = [UIColor menuYellowColor];
    
    UIBarButtonItem *spacerItem = [UIBarButtonItem flexSpacerItem];
    
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithTitle:@"Month" style:UIBarButtonItemStylePlain target:self action:@selector(monthPressed:)];
    
    UIBarButtonItem *button3 = [[UIBarButtonItem alloc]initWithTitle:@"Week" style:UIBarButtonItemStylePlain target:self action:@selector(weekPressed:)];
    
    UIBarButtonItem *button4 = [[UIBarButtonItem alloc]initWithTitle:@"Today" style:UIBarButtonItemStylePlain target:self action:@selector(todayPressed:)];
    
    [toolbar setItems:[[NSArray alloc] initWithObjects:button1, spacerItem, button3, spacerItem, button4, nil]];
    
    [self.view addSubview:toolbar];
    //self.calendarView.dataSource = self;
    //self.calendarView.delegate = self;
    //self.calendarView.swipeDelegate = self;
    
    self.title = self.calendarView.headerTitle;
    
    [self.view addSubview:self.calendarView];
}

-(void)addPlusButton
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEventPressed:)];
}

-(void)setMenuBarButton
{
    //self.navigationItem.rightBarButtonItem = [[MMDrawerBarButtonItem alloc]initWithTarget:self action:@selector(menuButtonPressed:)];
    
   // self.navigationController.navigationBar.tintColor = [UIColor menuSteelBlueColor];
}

-(void)menuButtonPressed:(id)sender
{
    //[((MMDrawerController*)self.navigationController.parentViewController) toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


-(void)addEventPressed:(id)sender
{
    NewEventViewController *newEventVC = [[NewEventViewController alloc]initWithNibName:@"NewEventViewController" bundle:nil];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:newEventVC];
    newEventVC.title = @"New Event";
    [self presentViewController:navC animated:YES completion:nil];
}

-(void)todayPressed:(id)sender
{
   //[self.calendarView setDate:[NSDate date] animated:NO];
    
   [self.calendarView setDisplayMode:CKCalendarViewModeDay];
}

-(void)weekPressed:(id)sender
{
   [self.calendarView setDisplayMode:CKCalendarViewModeWeek];
}

-(void)monthPressed:(id)sender
{
   [self.calendarView setDisplayMode:CKCalendarViewModeMonth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-EventStore methods

-(void)setupEventStore
{
    self.localEventStore = ((AppDelegate*) [UIApplication sharedApplication].delegate).eventStore;
    
    //For observing external changes to Calendar Database
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(eventStoreChanged:)
                                                 name:EKEventStoreChangedNotification
                                               object:self.localEventStore];
}

-(void)eventStoreChanged:(id)sender
{
    [self calendarView:self.calendarView eventsForDate:self.calendarView.date];
    
    //[self.calendarView reloa];
}

- (NSArray *)calendarView:(CalendarView *)calendarView eventsForDate:(NSDate *)date
{
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [self.localEventStore predicateForEventsWithStartDate:[NSDate calendarStartDateFromDate:date]
                                                                           endDate:[NSDate calendarEndDateFromDate:date]
                                                                         calendars:nil];
    // Fetch all events that match the predicate    
    return [self.localEventStore eventsMatchingPredicate:predicate];
}

#pragma mark-CKCalendarViewDelegate & DataSource methods

- (void)calendarView:(CalendarView *)CalendarView didSelectEvent:(EKEvent *)event
{
    NewEventViewController *newEventVC = [[NewEventViewController alloc]initWithEventViewMode];
    
    newEventVC.name = event.title;
    newEventVC.location = event.location;
    newEventVC.startDate = event.startDate;
    newEventVC.endDate = event.endDate;
    newEventVC.notes = event.notes;
    newEventVC.eventSelected = 1;
    newEventVC.calendar = self.calendarView.calendar;
    newEventVC.title = @"Event";
    newEventVC.event = event;
    
    [self.navigationController pushViewController:newEventVC animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
        
    //[self.calendarView reload];
}

-(void)calendarView:(CalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    if (self.calendarView.displayMode == CKCalendarViewModeMonth)
    {
      self.calendarView.displayMode = CKCalendarViewModeDay;
      self.calendarView.date = date;
    }
}

#pragma mark - CKCalendarViewTouch Delegate methods

-(void)swipeHappened
{
    self.title = self.calendarView.headerTitle;
}

-(void)todayViewHeader
{
    self.title = self.calendarView.headerTitle;
}

@end
