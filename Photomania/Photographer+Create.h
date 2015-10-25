//
//  Photographer+Create.h
//  Photomania
//
//  Created by admin on 25/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)
+(Photographer*)photographerWithName: (NSString*)name inManagedContext: (NSManagedObjectContext*) context;
@end
