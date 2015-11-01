//
//  TweetImageViewController.swift
//  Smashtag
//
//  Created by admin on 01/11/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class TweetImageViewController: UIViewController, UIScrollViewDelegate {
    var imageURLString: String?{
        didSet{
            if imageURLString != nil {
                imageURL = NSURL(string: imageURLString!)
                if view.window != nil{
                    fetchImage()
                }
            }
        }
    }
    private let imageView = UIImageView()
    private var imageURL: NSURL?
    private var image: UIImage?{
        didSet{
            imageView.image = image
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size ?? CGSizeZero
            autozoomToFit()
        }
    }
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        addConstraints()
        scrollView.delegate = self
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 3
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (image == nil){
            fetchImage()
        }
    }
    
    private func autozoomToFit(){
        if imageView.frame.width != 0 && imageView.frame.height != 0{
            scrollView.zoomScale = max(scrollView.frame.width / imageView.frame.width, scrollView.frame.height / imageView.frame.height)
        }
    }
    
    private func addConstraints(){
        view.addConstraints([
            NSLayoutConstraint(item: scrollView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(item: scrollView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(item: scrollView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Trailing,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(item: scrollView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: view,
                attribute: .Top,
                multiplier: 1.0,
                constant: 0
            )
            ])
    }
    
     func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
     }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        autozoomToFit()
    }
    
    private func fetchImage(){
        if let url = imageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            dispatch_async(dispatch_get_global_queue(qos, 0)){
                if let imageData = NSData(contentsOfURL: url){
                    dispatch_async(dispatch_get_main_queue()){
                        if url == self.imageURL{
                            self.image = UIImage(data: imageData)
                        } else {
                            self.image == nil
                        }
                    }
                }
            }
        }
    }
}
