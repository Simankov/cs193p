//
//  Photographer+Create.m
//  Photomania
//
//  Created by admin on 25/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "Photographer+Create.h"

@implementation Photographer (Create)
+(Photographer*)photographerWithName: (NSString*)name inManagedContext: (NSManagedObjectContext*) context
{
    Photographer * photographer = nil;
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    request.predicate = [NSPredicate predicateWithFormat:@"name=%@",name];
    NSError *error= nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (error || !matches || [matches count]>1){
        //handle errors
//        photographer = nil;
    } else if ([matches count]){
        photographer = [matches firstObject];
    } else {
        photographer = [NSEntityDescription insertNewObjectForEntityForName:@"Photographer" inManagedObjectContext:context];
        photographer.name = name;
    }
    
    return photographer;
}
@end

