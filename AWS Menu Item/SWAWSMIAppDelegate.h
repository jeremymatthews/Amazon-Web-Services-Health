//
//  SWAWSMIAppDelegate.h
//  AWS Menu Item
//
//  Created by Jeremy Matthews on 2/5/14.
//  Copyright (c) 2014 SISU Works LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SWAWSMIAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
