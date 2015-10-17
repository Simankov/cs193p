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

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.greenColor()
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.backgroundColor = UIColor.blackColor()

        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
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
            let imageData = NSData(contentsOfURL: imageUrl)
            if imageData != nil{
                image = UIImage(data: imageData!)
            } else {
                image = nil
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
                imageView.image = newValue
                imageView.sizeToFit()
                scrollView?.contentSize = imageView.bounds.size //why frame?? unknown for me
            }
        
        get{
            return imageView.image
        }
    }


}

