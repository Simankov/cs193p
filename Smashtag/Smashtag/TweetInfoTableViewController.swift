//
//  TweetInfoViewController.swift
//  Smashtag
//
//  Created by admin on 23/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class TweetInfoTableViewController : UITableViewController, UITableViewDelegate,UITableViewDataSource {
    var tweet: Tweet?{
        didSet{
           tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    struct Storyboard{
        static let TweetInfoViewCellIdentifier = "TweetInfoCell"
        static let TweetImageViewCellIdentifier = "TweetImageCell"
    }
    
    enum tweetSection: Int{
        case Hashtag, UserMention, URL, Image;
        static var count: Int {
            return Image.rawValue+1
        }
        
        var description: String{
            switch (self){
                case .UserMention: return "User mentions"
                case .Hashtag: return "Hashtags"
                case .URL: return "URLs"
                case .Image: return "Images"
            }
        }
    }
    
    override var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if let section = tweetSection(rawValue: indexPath.section){
                switch (section){
                case .URL:
                    let urlCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetInfoViewCellIdentifier) as? TweetTextInfoViewCell
                    urlCell?.tweetInfo.text = tweet?.urls[indexPath.row].keyword
                    return urlCell ?? cell
                    
                case .Hashtag:
                    let hashtagCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetInfoViewCellIdentifier) as? TweetTextInfoViewCell
                    hashtagCell?.tweetInfo.text = tweet?.hashtags[indexPath.row].keyword
                    return hashtagCell ?? cell
                    
                case .UserMention:
                    let userMentionCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetInfoViewCellIdentifier) as? TweetTextInfoViewCell
                    userMentionCell?.tweetInfo.text = tweet?.userMentions[indexPath.row].keyword
                    return userMentionCell ?? cell
                    
                case .Image :
                    let imageCell = tableView.dequeueReusableCellWithIdentifier(Storyboard.TweetImageViewCellIdentifier) as? TweetImageViewCell
                    imageCell?.imageURL = tweet?.media[indexPath.row].url
                    return imageCell ?? cell
                    
                }
            }
            return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count =  tweetSection.count
        return count
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if numberInSection(section) > 0 {
            if let tSection = tweetSection(rawValue: section){
                return tSection.description
            }
        }
        return nil
        
    }
    
    func numberInSection(section: Int)-> Int?{
        if let tweetSection = tweetSection(rawValue: section){
            switch (tweetSection){
            case .URL:
                return tweet?.urls.count
            case .UserMention:
                return tweet?.userMentions.count
            case .Hashtag:
                return tweet?.hashtags.count
            case .Image :
                return tweet?.media.count
            }
        }
        
        return nil
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = numberInSection(section){
            return count
        }
        return 0
    }
}
