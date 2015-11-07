//
//  TweetTabBarViewController.swift
//  Smashtag
//
//  Created by admin on 06/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit
import CoreData
class TweetTabBarViewController : UITabBarController{
    
    override func awakeFromNib() {
        NSNotificationCenter.defaultCenter().addObserverForName(NotificationNames.DatabaseAvailabilityNotificationName, object: nil, queue: NSOperationQueue.mainQueue()) { (note) -> Void in
            self.managedObjectContext = note.userInfo?[NotificationUserInfoKeys.DatabaseManagedObjectContextKey] as? NSManagedObjectContext
        }
    }
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        
         let tweetTableViewController = (self.viewControllers?[0] as? UINavigationController)?.topViewController as TweetTableViewController
        let tweetHistoryTableViewController = (self.viewControllers?[1] as? UINavigationController)?.topViewController as TweetHistoryTableViewController
        
        tweetTableViewController.managedObjectContext = managedObjectContext
        tweetHistoryTableViewController.managedObjectContext = managedObjectContext
    }
}