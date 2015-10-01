//
//  FaceView.swift
//  Happines
//
//  Created by sergey on 02.10.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import UIKit

class FaceView: UIView {
    
    var scale: CGFloat  = 0.9 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var lineWidth: CGFloat = 3.0 {
        didSet{setNeedsDisplay()}
    }
    
    var color : UIColor = UIColor.blueColor() {
        didSet{setNeedsDisplay()}
    }
    
    var faceCenter: CGPoint {
      return convertPoint(self.center, fromView: superview)
    }
    

   
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true);
        path.lineWidth = lineWidth;
        color.set()
        path.stroke()
    
    }
 

}
