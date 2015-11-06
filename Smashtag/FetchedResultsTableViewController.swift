//
//  TweeterHistoryViewController.swift
//  Smashtag
//
//  Created by admin on 05/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit
import CoreData
class FetchedResultsTableViewController : UITableViewController, NSFetchedResultsControllerDelegate{
    var fetchedController: NSFetchedResultsController! {
        didSet{
            if fetchedController != nil {
                fetchedController.delegate = self
                performFetch()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return fetchedController.sectionForSectionIndexTitle(title, atIndex: index)
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return fetchedController.sectionIndexTitles
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func performFetch(){
        let error = NSErrorPointer()
        fetchedController.performFetch(error)
        tableView.reloadData()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch(type){
                case NSFetchedResultsChangeType.Update :
                    tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
                case NSFetchedResultsChangeType.Insert :
                    tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
                case NSFetchedResultsChangeType.Delete :
                    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
                case NSFetchedResultsChangeType.Move :
                    tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
                    tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
            }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch(type){
        case .Delete: tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .None)
        case .Insert: tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .None)
        default: break
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}