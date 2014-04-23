//
//  CKCalendarHeaderView.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/14/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarHeaderView.h"

#import "CKCalendarHeaderColors.h"

#import "CKCalendarViewModes.h"

#import "UIColor+HexString.h"

@interface CKCalendarHeaderView ()
{
    NSUInteger _columnCount;
    CGFloat _columnTitleHeight;
}

@property (nonatomic, strong) UILabel *monthTitle;

@property (nonatomic, strong) NSMutableArray *columnTitles;
@property (nonatomic, strong) NSMutableArray *columnLabels;

@end

@implementation CKCalendarHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _monthTitle = [UILabel new];
        [_monthTitle setTextColor:kCalendarColorHeaderMonth];
        [_monthTitle setTextColor:[UIColor menuSteelBlueColor]];

     // [_monthTitle setShadowColor:kCalendarColorHeaderMonthShadow];
     // [_monthTitle setShadowOffset:CGSizeMake(0, 1)];
      [_monthTitle setBackgroundColor:[UIColor clearColor]];
      [_monthTitle setTextAlignment:NSTextAlignmentCenter];
      [_monthTitle setFont:[UIFont boldSystemFontOfSize:22]];
      
        _columnTitles = [NSMutableArray new];
        _columnLabels = [NSMutableArray new];
        
        _columnTitleHeight = 14;
    }
    return self;
}


- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self layoutSubviews];
    [super willMoveToSuperview:newSuperview];
    [self setBackgroundColor:[UIColor menuYellowColor]];
}

- (void)layoutSubviews
{
    /* Show & position the title Label */
    
    CGFloat upperRegionHeight = [self frame].size.height - _columnTitleHeight;
    CGFloat titleLabelHeight = 27;
    
    if ([[self dataSource] numberOfColumnsForHeader:self] == 0) {
        
        //day case
        titleLabelHeight = [self frame].size.height;
        upperRegionHeight = titleLabelHeight;
    }
    
    CGFloat yOffset = upperRegionHeight/2 - titleLabelHeight/2;
    
    CGRect frame = CGRectMake(0, yOffset, [self frame].size.width, titleLabelHeight);
    [[self monthTitle] setFrame:frame];
    [self addSubview:[self monthTitle]];
    
    /* Update the month title. */
    
    NSString *title = [[self dataSource] titleForHeader:self];
    [[self monthTitle] setText:title];
    
    /* Highlight the title color as appropriate */

    if ([self shouldHighlightTitle])
    {
       //[[self monthTitle] setTextColor:kCalendarColorHeaderTitleHighlightedBlue];
        
        [[self monthTitle] setTextColor:[UIColor whiteColor]];
    }
    else
    {
        [[self monthTitle] setTextColor:kCalendarColorHeaderMonth];
    }
    
    /*  Check for a data source for the header to be installed */
    if (![self dataSource]) {
        @throw [NSException exceptionWithName:@"CKCalendarViewHeaderException" reason:@"Header can't be installed without a data source" userInfo:@{@"Header": self}];
    }
    
    /* Query the data source for the number of columns. */
    _columnCount = [[self dataSource] numberOfColumnsForHeader:self];
    
    /* Remove old labels */
    
    for (UILabel *label in [self columnLabels]) {
        [label removeFromSuperview];
    }
    
    [[self columnLabels] removeAllObjects];
    
    /* Query the datasource for the titles.*/
    [[self columnTitles] removeAllObjects];
    
    for (NSUInteger column = 0; column < _columnCount; column++) {
        NSString *title = [[self dataSource] header:self titleForColumnAtIndex:column];
        [[self columnTitles] addObject:title];
    }
    
    /* Convert title strings into labels and lay them out */
    
    if(_columnCount > 0){
        CGFloat labelWidth = [self frame].size.width/_columnCount;
        CGFloat labelHeight = _columnTitleHeight;
        
        for (NSUInteger i = 0; i < [[self columnTitles] count]; i++) {
            NSString *title = [self columnTitles][i];
            
            UILabel *label = [self _columnLabelWithTitle:title];
            [[self columnLabels] addObject:label];
            
//            CGRect frame = CGRectMake(i*labelWidth, [self frame].size.height-labelHeight, labelWidth, labelHeight);
            CGRect frame = CGRectMake(i*labelWidth, [self frame].size.height/2-labelHeight/2, labelWidth, labelHeight);

            [label setFrame:frame];
            
            [self addSubview:label];
        }
    }
}

#pragma mark - Convenience Methods

/* Creates and configures a label for a column title */

- (UILabel *)_columnLabelWithTitle:(NSString *)title
{
    UILabel *l = [UILabel new];
    [l setBackgroundColor:[UIColor clearColor]];
   // [l setTextColor:kCalendarColorHeaderWeekdayTitle];
    [l setTextColor:[UIColor whiteColor]];
   // [l setShadowColor:kCalendarColorHeaderWeekdayShadow];
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setFont:[UIFont boldSystemFontOfSize:19]];
    //[l setShadowOffset:CGSizeMake(0, 1)];
    [l setText:title];
    
    return l;
}


#pragma mark - Title Highlighting

- (BOOL)shouldHighlightTitle
{
    if ([[self delegate] respondsToSelector:@selector(headerShouldHighlightTitle:)]) {
        return [[self dataSource] headerShouldHighlightTitle:self];
    }
    return NO;  //  Default is no.
}

@end
