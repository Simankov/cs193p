//
//  TweetInfoViewController.swift
//  Smashtag
//
//  Created by admin on 23/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class TweetMentionsTableViewController : UITableViewController, UITableViewDelegate,UITableViewDataSource {
    var tweet: Tweet?{
        didSet{
            tweetContent = getTweetContent()
            tableView.reloadData()
        }
    }
    
    private enum cellType: Int{
        case Hashtag, UserMention, URL, Image;
        static var count: Int {
            return Image.rawValue+1
        }
        var storyboardIdentifier: String{
            switch (self){
            case .UserMention,.Hashtag, .URL: return Storyboard.TweetKeywordViewCellIdentifier
            case .Image: return Storyboard.TweetImageViewCellIdentifier
            }
        }
        var header: String{
            switch (self){
            case .UserMention: return Headers.UserMention
            case .Hashtag: return Headers.Hashtag
            case .URL: return Headers.URL
            case .Image: return Headers.Image
            }
        }
    }

   private lazy var tweetContent: [String: [String]]? = self.getTweetContent()
    
   private func getTweetContent() -> [String: [String]]? {
        if let actualTweet = tweet {
            let hashtagsKeywords = actualTweet.hashtags.map{$0.keyword};
            let mediaURLS = actualTweet.media.map{$0.url.absoluteString!}
            let userMentionsKeywords = actualTweet.userMentions.map{$0.keyword}
            let urlsKeywords = actualTweet.urls.map{$0.keyword}
            return  [Headers.Hashtag : hashtagsKeywords,
                     Headers.URL : urlsKeywords,
                     Headers.Image : mediaURLS,
                     Headers.UserMention : userMentionsKeywords ]
        }
        return nil
    }
    
    private struct Storyboard{
        static let TweetKeywordViewCellIdentifier = "TweetKeywordCell"
        static let TweetImageViewCellIdentifier = "TweetImageCell"
        static let UnwindSegueToTweetTableIdentifier = "UnwindToTweetTable"
        static let SegueToTweetImageVCIdentifier = "ToTweetImageVC"
    }
    
    private struct Headers{
        static let URL = "URLs";
        static let UserMention = "User mentions";
        static let Image = "Images";
        static let Hashtag = "Hashtags";
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let section = cellType(rawValue: indexPath.section){
            if let content = tweetContent {
                cell = tableView.dequeueReusableCellWithIdentifier(section.storyboardIdentifier) as UITableViewCell
                    switch (section){
                        case .URL,.Hashtag, .UserMention:
                            (cell as? TweetKeywordViewCell)?.tweetInfoText = content[section.header]?[indexPath.row]
                        case .Image :
                            (cell as? TweetImageViewCell)?.imageURLString = content[section.header]?[indexPath.row]
                    }
            }
        }
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellType.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if numberInSection(section) > 0 {
            if let cell = cellType(rawValue: section){
                return cell.header
            }
        }
        return nil
    }
    
   override func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
            if let cell = cellType(rawValue: indexPath.section){
                switch (cell){
                    case .Image:
                        if let actualTweet = tweet {
                            return tableView.bounds.width / CGFloat(actualTweet.media[indexPath.row].aspectRatio)
                        }
                    default: break
                }
       
        }
      return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberInSection(section) ?? 0
    }
    
    override func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath){
            if let cell = cellType(rawValue: indexPath.section){
                switch(cell){
                    case .UserMention, .Hashtag:
                        performSegueWithIdentifier(Storyboard.UnwindSegueToTweetTableIdentifier, sender:    tweetContent?[cell.header]?[indexPath.row])
                    case .Image:
                        performSegueWithIdentifier(Storyboard.SegueToTweetImageVCIdentifier, sender: tweetContent?[cell.header]?[indexPath.row])
                    case .URL:
                        showInSafari(tweetContent?[cell.header]?[indexPath.row])
                }
            }
    }
    
    private func showInSafari(urlString: String?){
        if urlString != nil{
            if let url = NSURL(string: urlString!){
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    private func numberInSection(section: Int)-> Int?{
        if let cell = cellType(rawValue: section){
            if let count = tweetContent?[cell.header]?.count{
                return count
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            switch(identifier){
            case Storyboard.UnwindSegueToTweetTableIdentifier:
                if let tweetTableViewController = segue.destinationViewController as? TweetTableViewController{
                    tweetTableViewController.searchText = sender as? String
                }
            case Storyboard.SegueToTweetImageVCIdentifier:
                if let tweetImageViewController = segue.destinationViewController as? TweetImageViewController{
                    tweetImageViewController.imageURLString = sender as? String
                }
            default:  break
            }
        }
    }
}
