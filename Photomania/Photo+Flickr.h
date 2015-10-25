
//
//  Header.h
//  Photomania
//
//  Created by admin on 24/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#ifndef Photomania_Header_h
#define Photomania_Header_h
#import "Photo.h"
@interface Photo(Flickr)

+(Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

+(void)loadPhotosFromFlickrArray:(NSArray *)photos intoManagedObjectContext:(NSManagedObjectContext *)context;


@end
#endif
