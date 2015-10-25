//
//  CoreTableViewController.h
//  Photomania
//
//  Created by admin on 25/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreData;
@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong,nonatomic) NSFetchedResultsController *fetchedResultController;

-(void)performFetch;

@property BOOL debug;

@end
