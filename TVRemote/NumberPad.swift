//
//  NumberPad.swift
//  TVRemote
//
//  Created by Gary Roumanis on 11/23/14.
//  Copyright (c) 2014 SimplexSoftware. All rights reserved.
//

import UIKit

protocol NumberPadDelegate {
    func reactToButtonPress(button : RoundButton)
}

@IBDesignable class NumberPad: UIControl {
    
    var delegate : NumberPadDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutNumberGrid()
    }
    
    @IBInspectable var lineWidth: CGFloat = 1.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var margin : CGFloat = 0{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    private func layoutNumberGrid(){
        let (size, xOffset, yOffset) = getButtonSizeAndOffset()
        for(var i = 1; i < 10; i++){
            let pos = i - 1
            let x = (size + margin) * CGFloat(pos % 3) + xOffset
            let y = (size + margin) * CGFloat(pos / 3) + yOffset
            let button = RoundButton(frame: CGRectMake(x, y, size, size))
            button.lineWidth = self.lineWidth
            button.labelString = String(i)
            button.id = String(i)
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchDown)
            self.addSubview(button)
        }
        let button = RoundButton(frame: CGRectMake(size + margin + xOffset, (size + margin) * 3 + yOffset, size, size))
        button.lineWidth = self.lineWidth
        button.labelString = String(0)
        button.id = String(0)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchDown)
        self.addSubview(button)
    }
    
    private func getButtonSizeAndOffset() -> (size: CGFloat, xOffset: CGFloat, yOffset:CGFloat){
        let height = self.bounds.height / 4
        let width = self.bounds.width / 3
        let size = min(width - (2 * margin), height - (2 * margin))
        let actualWidth = 3 * size + 2 * margin
        let actualHeight = 4 * size + 3 * margin
        let xOffset = (self.bounds.width - actualWidth) / 2
        let yOffset = (self.bounds.height - actualHeight) / 2
        return (size, xOffset, yOffset)
    }
    
    func buttonPressed(sender : RoundButton){
        delegate?.reactToButtonPress(sender)
    }
    
}
