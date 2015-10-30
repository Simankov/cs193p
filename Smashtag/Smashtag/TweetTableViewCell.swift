//
//  TweetTableView.swift
//  Smashtag
//
//  Created by admin on 18/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//
import UIKit

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameOfUser: UILabel!
    @IBOutlet weak var textOfTweet: UILabel!
    
    @IBOutlet weak var imageOfUser: UIImageView!
    var tweet: Tweet?{
        didSet{
            updateUI()
        }
    }
    
    func setTextOfTweet() -> NSAttributedString?{
        if let actualTweet = tweet{
            
            var  attributedTweetText = NSMutableAttributedString(string: actualTweet.text)
            attributedTweetText.beginEditing()
            var fontOfLabel = textOfTweet.font
            
            var boldFont  = UIFont.boldSystemFontOfSize(textOfTweet.font.pointSize)
            
            for userMention in actualTweet.userMentions{
                attributedTweetText.addAttributes([kCTFontAttributeName : boldFont, NSForegroundColorAttributeName : UIColor.greenColor()], range: userMention.nsrange)
            }
            
            
            for hashtag in actualTweet.hashtags{
                attributedTweetText.addAttributes([kCTFontAttributeName : boldFont, NSForegroundColorAttributeName : UIColor.redColor()], range: hashtag.nsrange)
            }
            
            for url in actualTweet.urls{
                attributedTweetText.addAttributes([kCTFontAttributeName : boldFont, NSForegroundColorAttributeName : UIColor.blueColor()], range: url.nsrange)
            }
            
            attributedTweetText.endEditing()
            
            textOfTweet.attributedText = attributedTweetText
        }
        
        return nil
    }
    
    func updateUI(){
        
        nameOfUser?.text = tweet?.user.name
        setTextOfTweet()
        
        if let url =  tweet?.user.profileImageURL{
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue){
                if let data = NSData(contentsOfURL: url){
                    if let image = UIImage(data: data){
                        if url == self.tweet?.user.profileImageURL{
                            dispatch_async(dispatch_get_main_queue()){
                                self.imageOfUser.image = image
                            }
                        }
                    }
                }
            }
        }
    }
}
