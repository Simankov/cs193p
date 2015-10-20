//
//  GraphCalculatorView.swift
//  Calculator
//
//  Created by admin on 11/10/15.
//  Copyright (c) 2015 sergey. All rights reserved.
//

import UIKit

@IBDesignable

class GraphView: UIView {
    struct GraphViewConstants{
        static let scaleToPointsPerHashmarkAspectRatio: CGFloat = 100
    }

    @IBInspectable
    var scale: CGFloat = 1.0 {
        didSet{
            scale = max(scale,0.001)
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var color: UIColor = UIColor.blackColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineWidth: CGFloat = 1.0{
        didSet{
            setNeedsDisplay()
        }
    }

    
    var pointsPerUnit: CGFloat{
        return 1/self.contentScaleFactor*scale * GraphViewConstants.scaleToPointsPerHashmarkAspectRatio
    }

    var origin: CGPoint?{
        get{
            return dataSource?.originForGraphView(self)
        }
        
        set{
            setNeedsDisplay()
        }
    }
    weak var dataSource: DataSourceForGraphView?
    var axesDrawer = AxesDrawer()
  
    override func drawRect(rect: CGRect) {
        let centerOfView = CGPoint(x: CGRectGetMidX(bounds), y: CGRectGetMidY(bounds))
        //default value for origin is center
        var graphOrigin = origin ?? centerOfView
        axesDrawer.contentScaleFactor = self.contentScaleFactor
        axesDrawer.drawAxesInRect(rect, origin: graphOrigin, pointsPerUnit: pointsPerUnit)
        let offset = graphOrigin - centerOfView
        var isDiscontinuous = true
        let graphic = UIBezierPath()
        var i: CGFloat
        for i = -self.bounds.width/2-offset.x; i < self.bounds.width/2-offset.x; i += 1 {
            
            let x = Double(i)/Double(pointsPerUnit)
         

            if var y = dataSource?.valueFor(x,sender: self){
                if y.isNormal {
                    y *= Double(pointsPerUnit)
                    switch(isDiscontinuous){
                    case true:
                        graphic.moveToPoint(graphOrigin + CGPoint(x: Double(i), y: -y))
                        isDiscontinuous = false
                        
                    case false:
                        graphic.addLineToPoint(graphOrigin + CGPoint(x: Double(i), y: -y))
                     
                    default: break
                    }
                } else {
                    isDiscontinuous = true
                }
            } else {
                  isDiscontinuous = true
            }
        
        
        }
        graphic.lineWidth = lineWidth
        color.set()
        graphic.stroke()
       
    }
 
    func pinchRecognized(gesture: UIPinchGestureRecognizer){
        switch gesture.state{
        case .Changed, .Ended :
                 scale *= gesture.scale
                 gesture.scale = 1.0
            
            
        default: break
        }
    }
    
    
}
