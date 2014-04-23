//
//  AppDelegate.h
//  CalendarApp
//
//  Created by Sunayna Jain on 4/17/14.
//  Copyright (c) 2014 LittleAuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) EKEventStore *eventStore;

@property CGFloat navBarHeight;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
