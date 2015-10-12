//
//  GraphViewController.swift
//  Calculator
//
//  Created by admin on 11/10/15.
//  Copyright (c) 2015 sergey. All rights reserved.
//

import UIKit

protocol DataSourceForGraphView: class{
    
    func valueFor(x:Double,sender: GraphView) -> Double?
    func originForGraphView(sender: GraphView) -> CGPoint?
    
}




class GraphViewController : UIViewController, DataSourceForGraphView{
    private var brain: CalculatorBrain = CalculatorBrain()
    var program : AnyObject? {
        didSet {
            if let actualProgram = program{
                brain.program = actualProgram
            }
        }
    }
   
    @IBOutlet weak var functionName: UILabel!{
        didSet{
            functionName.text = functionDescription
        }
    }
    
    var functionDescription : String? {
        didSet{
            functionName?.text = functionDescription
            updateUI()
        }
    }
    
    @IBOutlet weak var graphView: GraphView!{
        didSet{
            graphView.dataSource = self
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: graphView, action: "pinchRecognized:")
            graphView.addGestureRecognizer(pinchGestureRecognizer)
            
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: "doubleTapRecognized:")
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            doubleTapGestureRecognizer.numberOfTouchesRequired = 1
            graphView.addGestureRecognizer(doubleTapGestureRecognizer)
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "panRecognized:")
            graphView.addGestureRecognizer(panGestureRecognizer)
        }
    }
    var origin: CGPoint?{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        graphView?.setNeedsDisplay()
    }
    
    override func viewDidLayoutSubviews() {
        origin  = CGPoint(x: graphView.bounds.width/2, y: graphView.bounds.height/2)
    }
    
    func valueFor(x: Double, sender: GraphView) -> Double?{
        return brain.setOperand("x", value: x)
    }
    
    func originForGraphView(sender: GraphView) -> CGPoint? {
        return origin
    }
    
    func panRecognized(gesture: UIPanGestureRecognizer){
        let translation = gesture.translationInView(graphView)
        switch(gesture.state){
        case .Changed,.Ended:
            
            origin  = origin! + translation
            gesture.setTranslation(CGPointZero, inView: graphView)
            
        default: break
        }
    }
    
    
    func doubleTapRecognized(gesture : UITapGestureRecognizer){
        if gesture.state == .Ended{
            let locationOfTap = gesture.locationInView(graphView)
            origin = locationOfTap
        }
    }
    
    
}


    public func + (left: CGPoint, right: CGPoint) -> CGPoint
      {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
      }

public func - (left: CGPoint, right: CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

