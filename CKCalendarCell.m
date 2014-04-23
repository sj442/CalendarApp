//
//  CKCalendarCalendarCell.m
//   MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarCell.h"
#import "CKCalendarCellColors.h"

//#import "UIView+Border.h"
#import <QuartzCore/QuartzCore.h>

@interface CKCalendarCell (){
    CGSize _size;
}

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *dot;

@end

@implementation CKCalendarCell

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        _state = CKCalendarMonthCellStateNormal;
        
        //  Normal Cell Colors
       // _normalBackgroundColor = kCalendarColorLightGray;
        _normalBackgroundColor = [UIColor whiteColor];

       // _selectedBackgroundColor = kCalendarColorBlue;
        _selectedBackgroundColor = [UIColor menuYellowColor];
        _inactiveSelectedBackgroundColor = kCalendarColorDarkGray;

        //  Today Cell Colors
       // _todayBackgroundColor = kCalendarColorBluishGray;
        _todayBackgroundColor = [UIColor menuSteelBlueColor];

       // _todaySelectedBackgroundColor = kCalendarColorBlue;
        _todaySelectedBackgroundColor = [UIColor menuYellowColor];

       // _todayTextShadowColor = kCalendarColorTodayShadowBlue;
        _todayTextShadowColor = [UIColor whiteColor];

        _todayTextColor = [UIColor whiteColor];
        
        //  Text Colors
        _textColor = kCalendarColorDarkTextGradient;
        _textShadowColor = [UIColor whiteColor];
        _textSelectedColor = [UIColor whiteColor];
        _textSelectedShadowColor = kCalendarColorSelectedShadowBlue;
        
        //_dotColor = kCalendarColorDarkTextGradient;
        _dotColor = [UIColor menuYellowColor];
        //_selectedDotColor = [UIColor whiteColor];

        _cellBorderColor = kCalendarColorCellBorder;
        _selectedCellBorderColor = kCalendarColorSelectedCellBorder;
        
        // Label
        _label = [UILabel new];
        
        //  Dot
        _dot = [UIView new];
        [_dot setHidden:YES];
        _showDot = NO;
    }
    return self;
}

- (id)initWithSize:(CGSize)size
{
    self = [self init];
    if (self)
    {
        _size = size;
    }
    return self;
}

#pragma mark - View Hierarchy

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    CGPoint origin = [self frame].origin;
    [self setFrame:CGRectMake(origin.x, origin.y, _size.width, _size.height)];
    [self layoutSubviews];
    [self applyColors];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [self configureLabel];
    [self configureDot];
    
    [self addSubview:[self label]];
    [self addSubview:[self dot]];
}

#pragma mark - Setters

- (void)setState:(CKCalendarMonthCellState)state
{
    if (state > CKCalendarMonthCellStateOutOfRange || state < CKCalendarMonthCellStateTodaySelected) {
        return;
    }
    _state = state;
    
    [self applyColorsForState:_state];
}

- (void)setNumber:(NSNumber *)number
{
    _number = number;
    
    //  TODO: Locale support?
    NSString *stringVal = [number stringValue];
    [[self label] setText:stringVal];
}

- (void)setShowDot:(BOOL)showDot
{
    _showDot = showDot;
    [[self dot] setHidden:!showDot];
}

#pragma mark - Recycling Behavior

-(void)prepareForReuse
{
    //  Alpha, by default, is 1.0
    [[self label]setAlpha:1.0];
    
    [[self label] setBackgroundColor:[UIColor clearColor]];
    
    [self setState:CKCalendarMonthCellStateNormal];
    
    [self applyColors];
}

#pragma mark - Label 

- (void)configureLabel
{
    UILabel *label = [self label];
    
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    [label setTextAlignment:NSTextAlignmentCenter];
    
   //[label setBackgroundColor:[UIColor clearColor]];
  //  [label setBackgroundColor:[UIColor menuYellowColor]];
   [label setFrame:CGRectMake(self.frame.size.width/4, 12, [self frame].size.width/2, [self frame].size.width/2)];
    
    label.layer.cornerRadius = [self frame].size.width/4;
    
    [label.layer setMasksToBounds:YES];
   // [label setFrame:CGRectMake(0, 0, [self frame].size.width, [self frame].size.height)];
}

#pragma mark - Dot

- (void)configureDot
{
    UIView *dot = [self dot];

    //CGFloat dotRadius = 3;

    CGFloat dotRadius = 12;
    CGFloat selfHeight = [self frame].size.height;
    CGFloat selfWidth = [self frame].size.width;
    
    [[dot layer] setCornerRadius:dotRadius/2];
    
    CGRect dotFrame = CGRectMake(selfWidth/2 - dotRadius/2, (selfHeight - (selfHeight/3)) - dotRadius/2, dotRadius, dotRadius);
    //CGRect dotFrame = CGRectMake(selfWidth/2 - dotRadius/2, (selfHeight - (selfHeight/5)) - dotRadius/2, dotRadius, dotRadius);

    [[self dot] setFrame:dotFrame];
}

#pragma mark - UI Coloring

- (void)applyColors
{    
    [self applyColorsForState:[self state]];
    //[self showBorder];
}

//  TODO: Make the cell states bitwise, so we can use masks and clean this up a bit
- (void)applyColorsForState:(CKCalendarMonthCellState)state
{
    //  Default colors and shadows
    [[self label] setTextColor:[self textColor]];
    //[[self label] setShadowColor:[self textShadowColor]];
    //[[self label] setShadowOffset:CGSizeMake(0, 0.5)];
    
   // [self setBorderColor:[self cellBorderColor]];
   // [self setBorderWidth:0.5];
    [self setBackgroundColor:[self normalBackgroundColor]];
    
    //  Today cell
    if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self.label setBackgroundColor:[UIColor menuYellowColor]];
        //[self setBackgroundColor:[self todaySelectedBackgroundColor]];
        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
       // [self setBorderColor:[self backgroundColor]];
    }
    
    //  Today cell, selected
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
       // [self.label setBackgroundColor:[UIColor menuSteelBlueColor]];
        [self.label setBackgroundColor:[UIColor menuYellowColor]];

        [[self label] setShadowColor:[self todayTextShadowColor]];
        [[self label] setTextColor:[self todayTextColor]];
       // [self setBorderColor:[self backgroundColor]];
       // [self showBorder];
    }
    
    //  Selected cells in the active month have a special background color
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self.label setBackgroundColor:[UIColor menuYellowColor]];
        //[self setBackgroundColor:[self selectedBackgroundColor]];
        //[self setBorderColor:[self selectedCellBorderColor]];
        
        
        [[self label] setTextColor:[self textSelectedColor]];
        //[[self label] setShadowColor:[self textSelectedShadowColor]];
        //[[self label] setShadowOffset:CGSizeMake(0, -0.5)];
    }
    
    if (state == CKCalendarMonthCellStateInactive) {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        //[[self label] setShadowOffset:CGSizeZero];
    }
    else if (state == CKCalendarMonthCellStateInactiveSelected)
    {
        [[self label] setAlpha:0.5];    //  Label alpha needs to be lowered
        //[[self label] setShadowOffset:CGSizeZero];
       [self setBackgroundColor:[self inactiveSelectedBackgroundColor]];
    }
    else if(state == CKCalendarMonthCellStateOutOfRange)
    {
        [[self label] setAlpha:0.01];    //  Label alpha needs to be lowered
        //[[self label] setShadowOffset:CGSizeZero];
    }
    
    //  Make the dot follow the label's style
    //[[self dot] setBackgroundColor:[self label].textColor];
    [[self dot] setBackgroundColor:[UIColor menuYellowColor]];
    [[self dot] setAlpha:[[self label] alpha]];
}

#pragma mark - Selection State

- (void)setSelected
{
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactive) {
        [self setState:CKCalendarMonthCellStateInactiveSelected];
    }
    else if(state == CKCalendarMonthCellStateNormal)
    {
        [self setState:CKCalendarMonthCellStateSelected];
    }
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setState:CKCalendarMonthCellStateTodaySelected];
    }
}

-(void)setSelectedForMonthMode
{
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactive) {
        [self setState:CKCalendarMonthCellStateInactiveSelected];
    }
    else if(state == CKCalendarMonthCellStateNormal)
    {
        //[self setState:CKCalendarMonthCellStateSelected];
        
        [self setState:CKCalendarMonthCellStateNormal];
    }
    else if(state == CKCalendarMonthCellStateTodayDeselected)
    {
        [self setState:CKCalendarMonthCellStateTodaySelected];
    }
}

- (void)setDeselected
{
    CKCalendarMonthCellState state = [self state];
    
    if (state == CKCalendarMonthCellStateInactiveSelected) {
        [self setState:CKCalendarMonthCellStateInactive];
    }
    else if(state == CKCalendarMonthCellStateSelected)
    {
        [self setState:CKCalendarMonthCellStateNormal];
    }
    else if(state == CKCalendarMonthCellStateTodaySelected)
    {
        [self setState:CKCalendarMonthCellStateTodayDeselected];
    }
}

- (void)setOutOfRange
{
    [self setState:CKCalendarMonthCellStateOutOfRange];
}

@end
