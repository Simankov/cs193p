//
//  FaceView.swift
//  Happines
//
//  Created by sergey on 02.10.15.
//  Copyright © 2015 sergey. All rights reserved.
//

import UIKit

protocol FaceViewDataSource: class{
    func getSmilinessForFaceView(sender: FaceView)->Double
}
@IBDesignable
class FaceView: UIView {
    
    weak var dataSource : FaceViewDataSource?
    
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
    
    var smiliness: Double{
        get{
            return  dataSource?.getSmilinessForFaceView(self) ?? 0.0
        }
        
    }
    
    
    private struct Scaling {
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
        
    }
    
    private enum Eye{
        case Left,Right
    }
    
    private func bezierPathForEye(whichEye: Eye) -> UIBezierPath {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeparation = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye{
        case .Left : eyeCenter.x -= eyeHorizontalSeparation/2
        case .Right : eyeCenter.x += eyeHorizontalSeparation/2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2*M_PI), clockwise: true)
        
        path.lineWidth = lineWidth
        return path
    }
    func pinch(gesture: UIPinchGestureRecognizer){
        switch gesture.state{
        case .Changed: fallthrough
        case .Ended: scale *= gesture.scale
        gesture.scale = CGFloat(1)
        default: break
        }
    }
    
    private func bezierPathForSmile(fractionOfMaxSmile: Double) -> UIBezierPath{
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile,1),-1))*mouthHeight
        let start = CGPoint(x: faceCenter.x - mouthWidth/2,y: faceCenter.y + mouthVerticalOffset)
        
        let end = CGPoint(x: start.x + mouthWidth,y: start.y)
        let cp1 = CGPoint(x: start.x+mouthWidth/3,y: start.y+smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth/3,y: cp1.y)
        
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
        
    }

   
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: CGFloat(0), endAngle: CGFloat(2*M_PI), clockwise: true);
        path.lineWidth = lineWidth;
        color.set()
        path.stroke()
        
        bezierPathForEye(.Left).stroke()
        bezierPathForEye(.Right).stroke()
        
        
        let smilePath = bezierPathForSmile(smiliness)
        smilePath.stroke()

    
    }
 

}
