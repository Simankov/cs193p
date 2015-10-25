//
//  CoreTableViewController.m
//  Photomania
//
//  Created by admin on 25/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "CoreDataTableViewController.h"

@implementation CoreDataTableViewController

#pragma mark - Fetching

-(void)performFetch{
    if (self.fetchedResultController){
        NSError * error;
        [self.fetchedResultController performFetch:&error];
    }
    
    [self.tableView reloadData];
}


-(void)setFetchedResultController:(NSFetchedResultsController *)newfrc{
    NSFetchedResultsController *oldfrc = _fetchedResultController;
    if (newfrc != oldfrc){
        _fetchedResultController = newfrc;
        newfrc.delegate = self;
    }
    if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)){
        self.title = newfrc.fetchRequest.entity.name;
    }
    if (newfrc){
        [self performFetch];
    } else {
        [self.tableView reloadData];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.fetchedResultController sections] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self.fetchedResultController sections] count] > 0){
        return [[self.fetchedResultController sections][section] numberOfObjects];
    } else {
        return 0;
    }
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return [self.fetchedResultController sectionIndexTitles];
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [self.fetchedResultController sectionForSectionIndexTitle:title atIndex:index];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[[self.fetchedResultController sections] objectAtIndex:section ]name];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
     [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
