//
//  ViewController.swift
//  Smashtag
//
//  Created by admin on 18/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit
import CoreData
class TweetTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{
    
    struct Storyboard{
        static let SegueIdentifierToTweetInfo = "ShowTweetInfo"
        static let CellReuseIdentificator = "TweetTableCell"
    }
    
 
    let kMaximumEntitiesInDatabase = 10
    var managedObjectContext : NSManagedObjectContext?
    var managedObjectIDToDelete: Int64 = 0; //implementing fifo with core data
    var searchText: String? = "@spbu"{
        didSet{
            if searchText != oldValue {
                tweets.removeAll()
                tableView.reloadData()
                searchField.text = searchText
                refresh(refreshControl)
                lastQuery = searchText
            } else {
                refresh(refreshControl)
            }
            title = searchText
        }
    }
    var tweets = [[Tweet]]()
    var lastTwitterRequest: TwitterRequest?

    var lastQuery: String?{
        didSet{
            if lastQuery != nil{
                insertEntityInDatabase(lastQuery!)
            }
        }
    }
    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.delegate = self
            searchField.text = searchText
        }
    }
        
    func request(){
        if let query = searchText {
            var request: TwitterRequest? = TwitterRequest(search: query, count: 100)
            self.refreshControl!.beginRefreshing()
            if lastTwitterRequest != nil {
                if query == lastQuery{
                    request = lastTwitterRequest!.requestForNewer
                }
            }
            request?.fetchTweets(){ tweets -> Void in
                if tweets.count > 0 {
                    dispatch_async(dispatch_get_main_queue()){
                        self.tweets.insert(tweets, atIndex: 0)
                        self.tableView.reloadData()
                        self.refreshControl?.endRefreshing()
                }
            } else {
                self.refreshControl?.endRefreshing()
                }
            }
            lastTwitterRequest = request
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh(refreshControl)
        title = searchText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentificator) as TweetTableViewCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Storyboard.SegueIdentifierToTweetInfo, sender: tweets[indexPath.section][indexPath.row])
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchField{
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    @IBAction func getBack(segue : UIStoryboardSegue){
        //for unwind segue. Data provided to current MVC from TweetMentionsMVC
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch (identifier){
                case Storyboard.SegueIdentifierToTweetInfo:
                    if let tweetMentionsTableViewController = segue.destinationViewController as? TweetMentionsTableViewController{
                        let tweet = sender as? Tweet
                        tweetMentionsTableViewController.tweet = tweet
                    }
                default: break
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    func insertEntityInDatabase(entityText: String){
        let fetchRequest = NSFetchRequest(entityName: "Query")
        let errorWhileCounting = NSErrorPointer()
        fetchRequest.predicate = nil //all
        let count = managedObjectContext?.countForFetchRequest(fetchRequest, error: errorWhileCounting)
        if count > kMaximumEntitiesInDatabase {
            let error = NSErrorPointer()
            let fetchRequestToDelete = NSFetchRequest(entityName: "Query")
            fetchRequestToDelete.fetchLimit = 1
            fetchRequestToDelete.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            let latestQuery = managedObjectContext?.executeFetchRequest(fetchRequestToDelete, error: error)?.first as NSManagedObject
            managedObjectContext?.deleteObject(latestQuery)
        }
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Query", inManagedObjectContext:   self.managedObjectContext!)
        let currentTime = NSDate()
        let formatter = NSDateFormatter()
        entity.setValue(currentTime, forKey: "date")
        entity.setValue(self.lastQuery!, forKey: "text")
        entity.setValue(count!+1, forKey: "id")
        let error = NSErrorPointer()
        self.managedObjectContext?.save(error)
        assert(error==nil && errorWhileCounting==nil, "\(error.memory?.description), \(errorWhileCounting.memory?.description)")
    }
    
    @IBAction func refresh(sender: UIRefreshControl!){
        request()
    }
    
}

