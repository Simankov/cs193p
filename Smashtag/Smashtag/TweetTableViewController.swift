//
//  ViewController.swift
//  Smashtag
//
//  Created by admin on 18/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class TweeterTableViewController: UITableViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate{

    var tweets = [[Tweet]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableViewAutomaticDimension
        
        request()
        
    }
   
    var searchText: String? = "#spbu"{
        didSet{
            tweets.removeAll()
            tableView.reloadData()
            request()
            searchField.text = searchText
        }
    }
        
    func request(){
        var request : TwitterRequest?
        if let query = searchText {
            if let lastRequest = lastTwitterRequest{
                request = lastRequest.requestForNewer
            } else {
                request = TwitterRequest(search: query, count: 100)
            }
            
        request?.fetchTweets(){ tweets -> Void in
            dispatch_async(dispatch_get_main_queue())
                {
                    self.tweets.insert(tweets, atIndex: 0)
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    var lastTwitterRequest: TwitterRequest?

    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.delegate = self
            searchField.text = searchText
        }
    }
    struct Storyboard{
        static let CellReuseIdentificator = "Reusable cell"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    @IBOutlet var tweetTableView: UITableView!{
        didSet{
            tweetTableView.delegate = self
            tweetTableView.dataSource = self
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentificator) as TweetTableViewCell
        
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchField{
            textField.resignFirstResponder()
            searchText = textField.text
            
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
}

