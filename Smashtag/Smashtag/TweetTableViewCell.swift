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
    
    func updateUI(){
        nameOfUser?.text = tweet?.user.name
        textOfTweet?.text = tweet?.text
        
    }
}
