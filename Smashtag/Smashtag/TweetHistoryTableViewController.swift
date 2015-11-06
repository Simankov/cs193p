//
//  TweetHistoryViewController.swift
//  Smashtag
//
//  Created by admin on 06/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit
import CoreData
class TweetHistoryTableViewController : FetchedResultsTableViewController {
    
    struct Storyboard {
        static let ShowRecentTweetsSegueIdentifier = "Show Recent Tweets"
    }
    
    var managedObjectContext : NSManagedObjectContext? {
        willSet{
            if newValue != nil {
                let childManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                childManagedObjectContext.parentContext = newValue!
                self.fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: newValue!, sectionNameKeyPath: nil, cacheName: nil)
            }
        }
    }
    
    let request: NSFetchRequest = {
        let fetchRequest = NSFetchRequest(entityName: "Query")
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return fetchRequest
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let error = NSErrorPointer()
        assert(error == nil, "\(error.memory?.description)")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Storyboard.ShowRecentTweetsSegueIdentifier, sender: tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if let identifier = segue.identifier{
            switch(identifier){
                case Storyboard.ShowRecentTweetsSegueIdentifier:
                    if let dvc = (segue.destinationViewController as?  UINavigationController)?.topViewController as? TweetTableViewController{
                        dvc.managedObjectContext = managedObjectContext
                        dvc.searchText = sender as? String
                    }
                default: break
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // so ugly becouse of unknown bag with core data
        let query = fetchedController.objectAtIndexPath(indexPath)
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = query.valueForKey("text") as String
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "HH:mm"
        var resultString = dateFormatter.stringFromDate(query.valueForKey("date") as NSDate)
        cell.detailTextLabel?.text = resultString
        return cell
    }
}