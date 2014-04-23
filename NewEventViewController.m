//
//  NewEventViewController.m
//  CRMStar
//
//  Created by Sunayna Jain on 2/11/14.
//  Copyright (c) 2014 Enhatch. All rights reserved.
//

#import "NewEventViewController.h"
#import "UIColor+EH.h"
#import "NSDate+Description.h"

@interface NewEventViewController ()

{
    CGFloat initialTVHeight;
    
    NSInteger startDatePickerIndex;
    
    NSInteger endDatePickerIndex;
    
    UITextView *notesTextView;
    
    UITextField *nameTextField;
    
    UITextField *locationTextField;
    
    UIDatePicker *startdatePicker;
    
    UIDatePicker *endDatePicker;
    
    UILabel *notesPlaceholderLabel;
    
    UIButton *deleteButton;
    
    UILabel *startTimeLabel;

    UILabel *endTimeLabel;
}

@end

@implementation NewEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        
        [self setupEventStore];
        
        [self addSaveButton];
        
        [self addCancelButton];
    }
    return self;
}

-(id)initWithEventViewMode{
    
    self = [super initWithNibName:@"NewEventViewController" bundle:nil];
    
    if (self)
    {
        [self setupEventStore];
        
        [self addCancelButton];
        
        [self addEditButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.calendarTableView.delegate = self;
    self.calendarTableView.dataSource = self;
    self.navigationController.navigationBar.tintColor = [UIColor menuSteelBlueColor];
    dateSection =1;
    startTimeIndex = 0;
    endTimeIndex = 1;
    startDatePickerIndex = 100;
    endDatePickerIndex = 100;
    rows=2;
    [self registerForKeyboardNotifications];
}

-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark-Navigation bar methods

-(void)addEditButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editButtonPressed:)];
}

-(void)addCancelButton
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelPressed:)];
}

-(void)addSaveButton
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

-(void)cancelPressed:(id)sender
{
    if (self.eventSelected==1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)editButtonPressed:(UIBarButtonItem*)sender
{
    if ([sender.title isEqualToString:@"Edit"])
    {
        self.title = @"Edit Event";
        sender.title = @"Save";
        
        nameTextField.userInteractionEnabled = YES;
        locationTextField.userInteractionEnabled = YES;
        notesTextView.userInteractionEnabled = YES;
        notesTextView.editable = YES;
        startdatePicker.userInteractionEnabled= YES;
        endDatePicker.userInteractionEnabled = YES;
        self.calendarTableView.userInteractionEnabled= YES;
        [self.calendarTableView reloadData];
        
    } else if (self.eventSelected==1 && [sender.title isEqualToString:@"Save"]){
        
        [self saveObjects];
        
        if (startdatePicker)
        {
            self.startDate = startdatePicker.date;
        }
        if (endDatePicker)
        {
            self.endDate = endDatePicker.date;
        }
        self.event.title = self.name;
        self.event.location = self.location;
        self.event.startDate = self.startDate;
        self.event.endDate = self.endDate;
        self.event.notes = self.notes;
        
        if ([self checkEventTimesAreValidForStartTime:self.startDate andEndTime:self.endDate])
        {
            [self saveEvent:self.event];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } else
        {
            [self eventTimesInvalidAlertView];
        }
    }
}

- (void)saveEvent :(EKEvent*)event
{
    NSError *error;
    [self.localEventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
    if (error)
    {
        NSLog(@"error %@", error);
    }
    else
    {
        NSLog(@"new event successfully added to calendar");
    }
}

-(void)savePressed:(id)sender
{
    [self saveObjects];
    
    if (!startdatePicker)
    {
        self.startDate = [NSDate date];
    } else
    {
        self.startDate = startdatePicker.date;
    }
    if (!endDatePicker)
    {
        self.endDate = [NSDate date];
        
    } else
    {
        self.endDate = endDatePicker.date;
        
    }
    if ([self checkEventTimesAreValidForStartTime:self.startDate andEndTime:self.endDate])
    {
    [self createCalendarEventwithName:self.name andLocation:self.location andDescription:self.notes andStartDate:self.startDate andEndDate:self.endDate];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } else
    {
        [self eventTimesInvalidAlertView];
    }
}

-(void)saveObjects
{
    self.name = nameTextField.text;
    self.location =locationTextField.text;
    self.notes = notesTextView.text;
}

-(void)deleteButtonPressed:(id)sender
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Are you sure you want to delete this event?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [alertview show];
}

#pragma mark-keyboard action methods

-(void)keyboardWillShow:(NSNotification*)notification
{
    initialTVHeight = self.calendarTableView.frame.size.height;
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self.view convertRect:initialFrame fromView:nil];
    CGRect tvFrame = self.calendarTableView.frame;
    tvFrame.size.height = convertedFrame.origin.y;
    self.calendarTableView.frame = tvFrame;
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    CGRect tvFrame = self.calendarTableView.frame;
    tvFrame.size.height = initialTVHeight;
    self.calendarTableView.frame = tvFrame;
    NSIndexPath *IP = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.calendarTableView cellForRowAtIndexPath:IP];
    
    [self.calendarTableView scrollRectToVisible:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) animated:YES];
}

#pragma mark- UITableViewDataSource methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.eventSelected==1)
    {
        return 4;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 44;
        
    } else if (indexPath.section==dateSection)
    {
        if (indexPath.row==startDatePickerIndex || indexPath.row==endDatePickerIndex)
        {
            return 200;
            
        } else
        {
            return 50;
        }
        
    } else if (indexPath.section==2)
    {
         return 150;
        
    } else if (indexPath.section==3)
    {
        return 50;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section<3)
    {
    return 36;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section<3)
    {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.calendarTableView.frame.size.width, 36)];
    
    [headerView setBackgroundColor:[UIColor menuYellowColor]];
    
    UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0, 160, headerView.frame.size.height)];
    
    if (section==0){
        headerLabel.text = @"DETAILS";
    }
    else if (section==1){
        headerLabel.text = @"TIME";
        
    } else if (section==2){
        headerLabel.text = @"DESCRIPTION";
    }
    headerLabel.textColor = [UIColor whiteColor];
    
    headerLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    [headerView addSubview:headerLabel];

    return headerView;
    }
    
    else {
    
    return nil;
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    notesTextView.delegate = nil;
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0){
        return 2;
    }
    if (section==dateSection){
        
        return rows;
    }
    else {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.section==0){
                
        static NSString *cellIdentifier = @"calendarEvent";
        
        cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
            if (indexPath.row==0){
                
                if (!cell){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, cell.contentView.frame.size.width-10, cell.frame.size.height)];
                    
                    nameTextField.delegate = self;
                    
                    [nameTextField setText:self.name];
                    
                    [cell addSubview:nameTextField];
                    
                    nameTextField.placeholder = @"Name";
                    
                    if (self.eventSelected==1)
                    {
                        nameTextField.userInteractionEnabled = NO;
                    }
                }
            } else if (indexPath.row==1){
                
                if (!cell){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    
                    locationTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, cell.contentView.frame.size.width-10, cell.frame.size.height)];
                    
                    locationTextField.delegate = self;
                    
                    [locationTextField setText:self.location];
                    
                    [cell addSubview:locationTextField];
                    
                    locationTextField.placeholder = @"Location";

                    if (self.eventSelected ==1){
                        locationTextField.userInteractionEnabled= NO;
                    }
                }
            }
    } else if (indexPath.section==dateSection){
        
        static NSString *CellIdentifier = @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //resetting the tag of the cell being reused
        
        cell.tag =indexPath.row;
        
        //0, 1, 2, 3..
        
        if (!cell){
            cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //setting the cell tag for a new cell
            
            cell.tag = indexPath.row;
        }
        
        if (self.eventSelected==1 && [self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"]){
            cell.userInteractionEnabled = NO;
        } else {
            cell.userInteractionEnabled=YES;
        }
        
        if (cell.tag==startTimeIndex){
            cell.textLabel.text = @"Start Time";
            cell.textLabel.textColor = [UIColor menuSteelBlueColor];
            startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, cell.frame.size.height)];
            cell.accessoryView = startTimeLabel;
            startTimeLabel.text = [self.startDate formattedString];
            
        } else if (cell.tag ==endTimeIndex){
            cell.textLabel.text = @"End Time";
            cell.textLabel.textColor = [UIColor menuSteelBlueColor];
            endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, cell.frame.size.height)];
            cell.accessoryView = endTimeLabel;
            endTimeLabel.text = [self.endDate formattedString];
            
        } else if (cell.tag == startDatePickerIndex) {
            [self createStartDatePickerForCell:cell];
            
            
        } else if (cell.tag == endDatePickerIndex){
            [self createEndDatePickerForCell:cell];
        }

    } else if (indexPath.section==2){
        
        static NSString *cellIdentifier = @"calendarEvent";
        
        cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            notesTextView = [[UITextView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 150)];
            notesTextView.font = [UIFont systemFontOfSize:15];
            notesTextView.text = self.notes;
            notesTextView.delegate =self;
            notesPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 0, 150, 30)];
            notesPlaceholderLabel.text = @"Notes";
            [notesPlaceholderLabel setFont:[UIFont systemFontOfSize:17]];
            notesPlaceholderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.7];
            if (self.eventSelected==0){
            [notesTextView addSubview:notesPlaceholderLabel];
            }
            [cell addSubview:notesTextView];
            
            if (self.eventSelected==1 && [self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"]) {
                notesTextView.userInteractionEnabled = YES;
                notesTextView.editable = NO;
            }
        }
        
    } else if (indexPath.section==3){
        
        static NSString *cellIdentifier = @"deleteCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            [deleteButton setTitle:@"Delete Event" forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [cell addSubview:deleteButton];
        }
    }
    return cell;
}

#pragma mark-UITextView Delegate methods

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSIndexPath *IP = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.calendarTableView cellForRowAtIndexPath:IP];
    NSLog(@"notes cell y origin %f", cell.frame.origin.y);
    NSIndexPath *path = [self.calendarTableView indexPathForRowAtPoint:CGPointMake(0, cell.frame.origin.y)];
    [self performSelector:@selector(scrollToCell:) withObject:path afterDelay:0.3f];
    }

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [self checkForPlaceholderLabelInNotesTextview];
            return NO;
        }
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.notes= notesTextView.text;
}

-(void)scrollToCell:(NSIndexPath*)path{
    [self.calendarTableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

-(void)checkForPlaceholderLabelInNotesTextview{
    if (notesTextView.text.length ==0){
        [notesTextView addSubview:notesPlaceholderLabel];
    } else if (notesTextView.text.length>0) {
        [notesPlaceholderLabel removeFromSuperview];
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    [self checkForPlaceholderLabelInNotesTextview];
}

#pragma mark-UITextField Delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField==nameTextField){
        [textField resignFirstResponder];
        self.name = nameTextField.text;
        [locationTextField becomeFirstResponder];
        
    } else if (textField==locationTextField){
        [textField resignFirstResponder];
        self.location = locationTextField.text;
    }
    return NO;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //enable saving only if the new event has a name
    
    UIBarButtonItem *saveButton = self.navigationItem.rightBarButtonItem;
    
    if (textField==nameTextField && (range.location>0 ||string.length>0)){
        
        if ([saveButton.title isEqualToString:@"Save"]){
            saveButton.enabled = YES;
        }
    } else if (textField==nameTextField && string.length==0 && range.location==0){
        
        if ([saveButton.title isEqualToString:@"Save"]){
            saveButton.enabled = NO;
        }
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//hide keyboard when start or end date cells are selected
    if (indexPath.section == dateSection){
        
        if (nameTextField.editing==YES){
            [nameTextField resignFirstResponder];
        } else if (locationTextField.editing==YES){
            [locationTextField resignFirstResponder];
        }
  
    [self.calendarTableView beginUpdates];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    selectedCell.tag = indexPath.row;
        
    if (selectedCell.tag==endTimeIndex && startDatePickerIndex!=100){
        
        [self hideStartDatePicker];
        
        [self showEndDatePicker];
        
    } else if (selectedCell.tag==startTimeIndex && endDatePickerIndex !=100){
        
        [self hideEndDatePicker];
        
        [self showStartDatePicker];
        
    } else if (selectedCell.tag ==startTimeIndex){
        
        if (startDatePickerIndex !=100){
            
            [self hideStartDatePicker];
            
        } else {
            
            [self showStartDatePicker];
        }
        
    } else if (selectedCell.tag == endTimeIndex){
        
        if (endDatePickerIndex !=100){
            
            [self hideEndDatePicker];
            
        } else {
            
            [self showEndDatePicker];
        }
    }
    
    else if (selectedCell.tag==startDatePickerIndex || selectedCell.tag ==endDatePickerIndex)
    {
        //do nothing
    }
    [self.calendarTableView endUpdates];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark-datepicker methods

-(void)createStartDatePickerForCell:(UITableViewCell*)cell
{
    NSArray *subviews = [cell.contentView subviews];
    for (UIView *subview in subviews){
        [subview removeFromSuperview];
    }
    
    if (cell.tag ==startDatePickerIndex)
    {
        startdatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [startdatePicker addTarget:self action:@selector(startDatePicked:) forControlEvents:UIControlEventValueChanged];
        [startdatePicker setDate:_startDate];
        [cell.contentView addSubview:startdatePicker];
    }
}

-(void)createEndDatePickerForCell:(UITableViewCell*)cell
{
    NSArray *subviews = [cell.contentView subviews];
    
    for (UIView *subview in subviews)
    {
        [subview removeFromSuperview];
    }
    
    if (cell.tag ==endDatePickerIndex)
    {
        endDatePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        [endDatePicker addTarget:self action:@selector(endDatePicked:) forControlEvents:UIControlEventValueChanged];
        [endDatePicker setDate:_endDate];
        [cell.contentView addSubview:endDatePicker];
    }
}

-(void)startDatePicked:(id)sender
{
    self.startDate = startdatePicker.date;
    startTimeLabel.text = [self.startDate formattedString];
}

-(void)endDatePicked:(id)sender
{
    self.endDate = endDatePicker.date;
    endTimeLabel.text = [self.endDate formattedString];
}

-(void)showStartDatePicker
{
    startDatePickerIndex = startTimeIndex+1;
    endTimeIndex = endTimeIndex+1;
    NSIndexPath *startDatePickerIP = [NSIndexPath indexPathForRow:startDatePickerIndex inSection:dateSection];
    [self.calendarTableView insertRowsAtIndexPaths:@[startDatePickerIP] withRowAnimation:UITableViewRowAnimationFade];
    rows++;
}

-(void)hideStartDatePicker
{
    NSIndexPath *deleteStartDatePickerIP = [NSIndexPath indexPathForRow:startDatePickerIndex inSection:dateSection];
    [self.calendarTableView deleteRowsAtIndexPaths:@[deleteStartDatePickerIP] withRowAnimation:UITableViewRowAnimationFade];
    endTimeIndex--;
    rows--;
    startDatePickerIndex=100;
}

-(void)showEndDatePicker
{
    endDatePickerIndex = endTimeIndex+1;
    NSIndexPath *endDatePickerIP = [NSIndexPath indexPathForRow:endDatePickerIndex inSection:dateSection];
    [self.calendarTableView insertRowsAtIndexPaths:@[endDatePickerIP] withRowAnimation:UITableViewRowAnimationFade];
    rows++;
}

-(void)hideEndDatePicker
{
    NSIndexPath *deleteEndDatePickerIP = [NSIndexPath indexPathForRow:endDatePickerIndex inSection:dateSection];
    [self.calendarTableView deleteRowsAtIndexPaths:@[deleteEndDatePickerIP] withRowAnimation:UITableViewRowAnimationFade];
    rows--;
    endDatePickerIndex = 100;
}

-(BOOL)checkEventTimesAreValidForStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime
{
    return [NSDate checkIfFirstDate:startTime isSmallerThanSecondDate:endTime];
}

-(void)eventTimesInvalidAlertView
{
    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error!" message:@"End time cannot be smaller than start time" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alertview show];
}


-(void)createCalendarEventwithName:(NSString*)name andLocation:(NSString*)location andDescription:(NSString*)notes andStartDate:(NSDate*)startDate andEndDate:(NSDate*)endDate
{
    EKEvent *newEvent = [EKEvent eventWithEventStore:self.localEventStore];
    
    newEvent.title = name;
    newEvent.startDate = self.startDate;
    newEvent.endDate = self.endDate;
    newEvent.timeZone = [NSTimeZone localTimeZone];
    newEvent.location = location;
    newEvent.notes = self.notes;
    newEvent.calendar = [self.localEventStore defaultCalendarForNewEvents];
    [self saveEvent:newEvent];
}

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
    NSLog(@"Event store changed newEventVC");
}

#pragma mark-UIAlertView Delegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSError *error;
        [self.localEventStore removeEvent:self.event span:EKSpanThisEvent error:&error];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
