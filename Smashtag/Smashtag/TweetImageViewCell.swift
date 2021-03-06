//
//  TweetImageViewCell.swift
//  Smashtag
//
//  Created by admin on 23/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class TweetImageViewCell: UITableViewCell{
    @IBOutlet private weak var tweetImageView: UIImageView!
    
    private var tweetImage: UIImage?{
        willSet{
            tweetImageView?.image = newValue
        }
    }
    var imageURLString: String?{
        didSet{
            if imageURLString != nil {
                imageURL = NSURL(string: imageURLString!)
                updateUI()
            }
        }
    }
   private var imageURL : NSURL?
    
   private func updateUI(){
        if imageURL != nil {
           let qos = Int(QOS_CLASS_USER_INITIATED.value);
            if let url = imageURL{
                dispatch_async(dispatch_get_global_queue(qos, 0)){
                    if let imageData = NSData(contentsOfURL: url){
                       dispatch_async(dispatch_get_main_queue()){
                            if url == self.imageURL{
                                self.tweetImage = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
        }
    }
}

