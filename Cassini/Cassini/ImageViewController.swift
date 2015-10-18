//
//  ViewController.swift
//  Cassini
//
//  Created by admin on 17/10/15.
//  Copyright (c) 2015 A. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageURL: NSURL?{
        didSet{
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    let spinningWheel = UIActivityIndicatorView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 100, height: 100)))

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: view.bounds)
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        spinningWheel.setTranslatesAutoresizingMaskIntoConstraints(false)
        spinningWheel.color = UIColor.blackColor()
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        view.addSubview(spinningWheel)
        setupConstraints()
    }
    
    

    private var imageView = UIImageView()
    var scrollView : UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 2
        }
    }
    
    func fetchImage(){
        
        if let imageUrl = imageURL{
            let qos = Int(QOS_CLASS_USER_INITIATED.value)
            let queue = dispatch_get_global_queue(qos, 0)
            dispatch_async(queue){
                self.spinningWheel.startAnimating()
                let imageData = NSData(contentsOfURL: imageUrl)
                
                dispatch_async(dispatch_get_main_queue()){
                    if imageUrl == self.imageURL {
                        if imageData != nil{
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
      
        if image == nil{
            fetchImage()
        }
    }
    
    
    private func setupConstraints(){

        
        view.addConstraints([
            
            NSLayoutConstraint(
                item: spinningWheel,
                attribute: .CenterX,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterX,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: spinningWheel,
                attribute: .CenterY,
                relatedBy: .Equal,
                toItem: view,
                attribute: .CenterY,
                multiplier: 1,
                constant: 0),


            NSLayoutConstraint(
                item: scrollView,
                attribute: .Leading,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Leading,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: scrollView,
                attribute: .Trailing,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Trailing,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item:scrollView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1,
                constant: 0),

            NSLayoutConstraint(
                item: scrollView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0),
            ])
    }
    
    private var image: UIImage?{
        set{
                spinningWheel.stopAnimating()
                imageView.image = newValue
                imageView.sizeToFit()
                scrollView?.contentSize = imageView.bounds.size //why frame?? unknown for me
            
            }
        
        get{
            return imageView.image
        }
    }


}

