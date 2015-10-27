//
//  PhotographerCDTV.m
//  Photomania
//
//  Created by admin on 25/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "PhotographerCDTV.h"
#import "Photographer.h"
#import "PhotoDatabaseAvailability.h"
@implementation PhotographerCDTV

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter]addObserverForName:PhotoDatabaseAvailabilityNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.managedObjectContext = note.userInfo[PhotoDatabaseAvailabilityNotificationContext];
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier: @"Photographer Cell"];
    Photographer * photographer = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.textLabel.text = photographer.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",[photographer.photos count]];
    return cell;
}


-(void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
    _managedObjectContext = managedObjectContext;
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:@"Photographer"];
    NSPredicate * all = nil;
                                NSSortDescriptor * sort = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                                    ascending:(YES)
                                                                                       selector:@selector(localizedStandardCompare:)];
    request.predicate = all;
    request.sortDescriptors = @[sort];
    self.fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                       managedObjectContext:managedObjectContext
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];

}

@end
