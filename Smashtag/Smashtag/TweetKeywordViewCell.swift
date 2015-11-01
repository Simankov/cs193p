//
//  TweetTextInfoViewCell.swift
//  Smashtag
//
//  Created by admin on 23/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//
import UIKit
// info means hashtag || url || userMentions

class TweetKeywordViewCell: UITableViewCell{
    
    @IBOutlet private weak var tweetInfo: UILabel!
    
    
    var tweetInfoText : String?{
        didSet{
            updateUI()
        }
    }
    
    
    
    private func updateUI(){
        tweetInfo?.text = tweetInfoText
    }

}
