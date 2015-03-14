//
//  RoundButton.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/20/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIControl {
    
    private var circleBackground : CAShapeLayer!
    private var textLabel : UILabel!
    private var size : CGFloat?
    
    @IBInspectable var id : String = ""
    
    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var pressAlpha: CGFloat = 0.75 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var labelString : String = "" {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCircleBackground()
        layoutLabel()
    }
    
    private func layoutCircleBackground(){
        let shapeLayer = CAShapeLayer()
        let size = self.getSize()
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: (self.bounds.width - size) / 2, y: (self.bounds.height - size) / 2, width: size, height: size), cornerRadius: size/2).CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = tintColor?.CGColor
        shapeLayer.lineWidth = lineWidth
        circleBackground = shapeLayer
        self.layer.insertSublayer(shapeLayer, atIndex: 0)
    }
    
    private func layoutLabel(){
        let size = self.getSize()
        let label = UILabel(frame: CGRectMake(0, 0, size, size))
        label.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        label.text = labelString
        label.textColor = tintColor
        label.textAlignment = NSTextAlignment.Center
        textLabel = label
        self.addSubview(label)
    }
        
    private func getSize() -> CGFloat{
        return min(self.bounds.width - 2 * lineWidth, self.bounds.height - 2 * lineWidth)
    }
    
    override func intrinsicContentSize() -> CGSize {
        let size = self.getSize()
        return CGSize(width: size, height: size)
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        let point = self.layer.convertPoint(touch.locationInView(self), toLayer: circleBackground)
        if CGPathContainsPoint(circleBackground.path, nil, point, true) {
            circleBackground.fillColor = CGColorCreateCopyWithAlpha(tintColor.CGColor, pressAlpha)
            return true
        }
        return false
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        returnColor()
    }
    
    private func returnColor(){
        let duration = 0.5
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fromValue = circleBackground.fillColor
        colorAnimation.toValue = UIColor.clearColor().CGColor
        colorAnimation.duration = duration
        colorAnimation.repeatCount = 0
        colorAnimation.autoreverses = false
        circleBackground.fillColor = UIColor.clearColor().CGColor
        circleBackground.addAnimation(colorAnimation, forKey: "fillColor")
    }
}
