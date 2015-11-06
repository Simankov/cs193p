//
//  Smashtag.swift
//  Smashtag
//
//  Created by admin on 06/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import Foundation
import CoreData

class Smashtag: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var text: String
    @NSManaged var id: NSNumber

}
