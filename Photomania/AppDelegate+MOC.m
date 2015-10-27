//
//  AppDelegate+MOC.m
//  Photomania
//
//  Created by admin on 26/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "AppDelegate+MOC.h"
#import <CoreData/CoreData.h>

@implementation AppDelegate (MOC)
-(void)saveContext: (NSManagedObjectContext *)managedObjectContext{
    NSError *error = nil;
    if (managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save: &error]){
            abort();
        }
    }
}

-(NSPersistentStoreCoordinator *)createPersistentStoreCoordinator{
    NSPersistentStoreCoordinator * coordinator= nil;
    NSManagedObjectModel * model = nil;
    NSError *error = nil;
    model = [self createManagedObjectModel];
    if (model != nil) {
        coordinator =  [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    }
    NSURL* storeURL =  [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"MOC.sqlite"];
    
    if (coordinator != nil){
        if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return coordinator;
}
-(NSManagedObjectContext *)createMainQueueManagedObjectContext{
    NSManagedObjectContext *managedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = [self createPersistentStoreCoordinator];
    if (coordinator != nil){
     managedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return managedObjectContext;
}

-(NSManagedObjectModel *)createManagedObjectModel{
    NSManagedObjectModel *model = nil;
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    return model;
    
}
@end;
