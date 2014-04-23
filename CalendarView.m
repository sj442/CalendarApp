//
//  CalendarView.m
//  CalendarApp
//
//  Created by Sunayna Jain on 4/21/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.

#import "CalendarView.h"
#import "CalendarCell.h"
#import "NSCalendar+Juncture.h"
#import "NSCalendar+Components.h"
#import "NSDate+Format.h"
#import "CalendarViewController.h"
#import "NSDate+Description.h"

@implementation CalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.calendar = [NSCalendar currentCalendar];
        
        self.date = [NSDate createDateFromComponentsYear:2014 andMonth:2 andDay:10];
        
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView.collectionViewLayout = self.flowLayout;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:self.flowLayout];
        
        [self addSubview:self.collectionView];
        
        [self.flowLayout setItemSize:[self cellSize]];
        
        [self.flowLayout setMinimumLineSpacing:1];
        
        [self.flowLayout setMinimumInteritemSpacing:1];
        
        self.collectionView.dataSource = self;
        
        self.collectionView.delegate = self;
        
        self.firstVisibleDate= [self getFirstVisibleDate];
        
        self.lastVisibleDate=[self getLastVisibleDate];
        
        [self.collectionView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        
        UINib *nib = [UINib nibWithNibName:@"CalendarCell" bundle:nil];
        
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CalendarCell"];
        
        self.collectionView.backgroundColor = [UIColor redColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.collectionView.frame.size.height, self.frame.size.width, self.frame.size.height-self.collectionView.frame.size.height)];
        
        self.tableView.delegate = self;
        
        self.tableView.dataSource = self;
        
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)layoutSubviewsForWeek
{
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, [self cellSize].height);
    
    self.tableView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.frame.size.width, self.frame.size.height-self.collectionView.frame.size.height);
    
    [self.collectionView reloadData];
}

-(void)layoutSubviewForMonth
{
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.tableView.frame = CGRectMake(0, self.collectionView.frame.size.height, self.frame.size.width, self.frame.size.height-self.collectionView.frame.size.height);
    
    [self.collectionView reloadData];
}

-(void)layoutSubviewForDay
{
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.collectionView.frame = CGRectMake(0, self.tableView.frame.size.height, self.frame.size.width, self.frame.size.height - self.tableView.frame.size.height);
    
    [self.collectionView reloadData];
}

#pragma mark-UICollectionView dataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

#pragma mark-UICollectionView Delegate

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = (CalendarCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath ];
    
    NSInteger index = indexPath.section*7 +indexPath.row +1;
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.displayMode==CKCalendarViewModeDay)
    {
        cell.dateLabel.text = @"";
    }
    
    else if (self.displayMode ==CKCalendarViewModeMonth)
        
    {
        if (index< [self getFirstVisibleDateDay])
        {
          cell.dateLabel.text = @"";
        }
        else if ( index>=[self getFirstVisibleDateDay] && index < [self.calendar daysInDate:self.lastVisibleDate]+[self getFirstVisibleDateDay])
        {
            cell.dateLabel.text = [NSString stringWithFormat:@"%d", index-[self.calendar weekdayInDate:self.firstVisibleDate]+1];
        }
        else
        {
           cell.dateLabel.text = @"";
        }
    }
    else
    {
        //week view
    }
    
    cell.dateLabel.textColor = [UIColor blackColor];
    
    cell.dateLabel.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (void)reload
{
    //later
}

-(CGSize)cellSize
{
    return CGSizeMake(40,(self.frame.size.height)/7);
}

#pragma mark- UITableView Delegate & DataSource methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = @"No Events";
    
    return cell;
}

-(NSInteger)getFirstVisibleDateDay
{
    return [self.calendar weekdayInDate:self.firstVisibleDate];
}

-(NSDate*)getFirstVisibleDate
{
    if (self.displayMode==CKCalendarViewModeMonth)
    {
        self.firstVisibleDate= [self.calendar firstDayOfTheMonthUsingReferenceDate:self.date];
    }
    else if (self.displayMode == CKCalendarViewModeWeek)
    {
        self.firstVisibleDate = [self.calendar firstDayOfTheWeekUsingReferenceDate:self.date];
    }
    return self.firstVisibleDate;
}

-(NSDate*)getLastVisibleDate
{
    if (self.displayMode==CKCalendarViewModeMonth)
    {
        self.lastVisibleDate= [self.calendar lastDayOfTheMonthUsingReferenceDate:self.date];
    }
    else if (self.displayMode == CKCalendarViewModeWeek)
    {
        self.lastVisibleDate = [self.calendar lastDayOfTheMonthUsingReferenceDate:self.date];
    }
    return self.lastVisibleDate;
}

-(NSInteger)getLastVisibleDateDay
{
    return [self.calendar weekdayInDate:self.lastVisibleDate];
}

-(void)removeAllGestureRecognizers
{
    for (UISwipeGestureRecognizer *recognizer in self.gestureRecognizers)
    {
        [self removeGestureRecognizer:recognizer];
    }
}

-(void)addMonthSwipeGestureRecognizers
{
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(upSwipeHappened:)];
    
    upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(downSwipeHappened:)];
    
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self addGestureRecognizer:downSwipe];
}

-(void)upSwipeHappened:(id)sender
{
    NSInteger month = [self.calendar monthsInDate:self.date];
    
    NSInteger year = [self.calendar yearsInDate:self.date];
    
    NSDate *newDate = [NSDate createDateFromComponentsYear:year andMonth:month+1 andDay:1];
    
    self.date = newDate;
    
    [self.swipeDelegate newDateToPassBack:newDate];
    
    self.firstVisibleDate= [self getFirstVisibleDate];
    
    self.lastVisibleDate=[self getLastVisibleDate];
    
    [self.collectionView reloadData];
}

-(void)downSwipeHappened:(id)sender
{
    NSInteger month = [self.calendar monthsInDate:self.date];
    
    NSInteger year = [self.calendar yearsInDate:self.date];
    
    NSDate *newDate = [NSDate createDateFromComponentsYear:year andMonth:month-1 andDay:1];
    
    self.date = newDate;
    
    [self.swipeDelegate newDateToPassBack:newDate];
    
    self.firstVisibleDate= [self getFirstVisibleDate];
    
    self.lastVisibleDate=[self getLastVisibleDate];
    
    [self.collectionView reloadData];
}

-(void)addWeekSwipeGestureRecognizers
{
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipeHappened:)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipeHappened:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:rightSwipe];
}

-(void)leftSwipeHappened:(id)sender
{
    
}

-(void)rightSwipeHappened:(id)sender
{
    
}


@end
