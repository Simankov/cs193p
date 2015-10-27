//
//  Photo+Flickr.m
//  Photomania
//
//  Created by admin on 24/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Photographer+Create.h"
@import CoreData;

@implementation Photo(Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    NSString* unique = photoDictionary[FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique=%@",unique];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || [matches count]>1){
        //handle errors
    } else if ([matches count]){
        photo = [matches firstObject];
    } else {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        photo.unique = [photoDictionary valueForKeyPath:FLICKR_PHOTO_ID];
        
        NSString *name = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
        
        photo.whoTook = [Photographer photographerWithName:name inManagedContext:context];
        
    }
    
    
    
    return photo;
}

+(void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *photoData in photos){
        [self photoWithFlickrInfo:photoData inManagedObjectContext:context];
    }
}

@end