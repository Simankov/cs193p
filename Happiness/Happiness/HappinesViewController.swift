//
//  HappinesViewController.swift
//  Happines
//
//  Created by sergey on 02.10.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import UIKit

class HappinesViewController: UIViewController, FaceViewDataSource
{
    var happiness:Int = 50{
        didSet{
            happiness = max(min(happiness,100),0)
            updateUI()
        }
        
    }
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "pan:")
            
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: "pinch:")
            faceView.addGestureRecognizer(gestureRecognizer)
            faceView.addGestureRecognizer(pinchRecognizer)
            faceView.dataSource = self
        }
    }
    
    func updateUI(){
        faceView.setNeedsDisplay()
    }
    
    func getSmilinessForFaceView(sender: FaceView) -> Double {
        return Double(happiness-50)/50
    }
    
    
    func pan(gesture: UIPanGestureRecognizer){
        
        switch gesture.state {
        case .Changed: fallthrough
        case .Ended:
            
            let translation = gesture.translationInView(gesture.view)
            happiness = happiness - Int(translation.y)
            gesture.setTranslation(CGPointZero, inView: gesture.view)
            
        default : break
        }
        
    }

    
}
