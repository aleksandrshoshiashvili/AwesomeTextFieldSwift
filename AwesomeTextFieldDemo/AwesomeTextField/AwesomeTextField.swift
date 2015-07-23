//
//  AwesomeTextField.swift
//  AwesomeTextField
//
//  Created by MacBookPro on 22.07.15.
//  Copyright (c) 2015 MacBookPro. All rights reserved.
//

import UIKit

@IBDesignable

class AwesomeTextField: UITextField {
    
    @IBInspectable var underLineWidth : CGFloat = 2.0
    @IBInspectable var underLineColor : UIColor = UIColor.blackColor()
    @IBInspectable var underLineAlpha : CGFloat = 0.5
    
    @IBInspectable var placeholderTextColor : UIColor = UIColor.grayColor()
    
    @IBInspectable var animationDuration : NSTimeInterval = 0.35
    
    let scaleCoeff : CGFloat = 0.75
    let textInsetX : CGFloat = 1.5
    let placeholderAlphaAfter : CGFloat = 0.85
    let placeholderAlphaBefore : CGFloat = 0.5
    
    var placeholderLabel = UILabel(frame: CGRectMake(0, 0, 0, 0))
    var underlineView = UIView(frame: CGRectMake(0, 0, 0, 0))
    var isLifted = false
    
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.drawLine()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBeginChangeText", name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didChangeText", name: UITextFieldTextDidChangeNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEndChangeText", name: UITextFieldTextDidEndEditingNotification, object: self)
        
    }
    
    func drawLine() {
        
        var underLine = UIView(frame:CGRectMake(0, self.frame.size.height - self.underLineWidth, self.frame.size.width, self.underLineWidth))
        
        underLine.backgroundColor = self.underLineColor
        underLine.alpha = self.underLineAlpha
        
        self.underlineView = underLine
        
        self.addSubview(self.underlineView)
        
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        
        super.drawPlaceholderInRect(rect)
        
        self.placeholderLabel = UILabel(frame: CGRectMake(rect.origin.x, self.underLineWidth, rect.size.width, self.font.pointSize))
        self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x, self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font.fontName, size: self.font.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaBefore
        
        self.addSubview(self.placeholderLabel)
        self.bringSubviewToFront(self.placeholderLabel)
        
    }
    
    func drawPlaceholderIfTextExistInRect(rect: CGRect) {
        
        self.placeholderLabel = UILabel(frame: CGRectMake(rect.origin.x, self.underLineWidth, rect.size.width, self.font.pointSize))
        self.placeholderLabel.transform = CGAffineTransformMakeScale(self.scaleCoeff, self.scaleCoeff)
        self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x * self.scaleCoeff, 0 + self.placeholderLabel.frame.size.height)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font.fontName, size: self.font.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaAfter
        self.isLifted = true
        
        self.addSubview(self.placeholderLabel)
        self.bringSubviewToFront(self.placeholderLabel)
        
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(rect)
        
        if let placeholderText = self.placeholder {
            self.drawPlaceholderIfTextExistInRect(rect)
        }
        
        self.textAlignment = .Left
        self.contentVerticalAlignment = .Bottom
        
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .Left
        self.contentVerticalAlignment = .Bottom
        return CGRectInset(bounds, self.textInsetX, insetForY)
        
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .Left
        self.contentVerticalAlignment = .Bottom
        return CGRectInset(bounds, self.textInsetX, insetForY)
    }
    
    // MARK: - Delegate
    
    func didBeginChangeText() {
        
        if !self.isLifted {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.placeholderLabel.transform = CGAffineTransformMakeScale(self.scaleCoeff, self.scaleCoeff)
                self.placeholderLabel.alpha = self.placeholderAlphaAfter
                self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x * self.scaleCoeff, 0 + self.placeholderLabel.frame.size.height)
                
                self.underlineView.alpha = 1.0
                
            }, completion: { (finished) -> Void in
                if finished {
                    self.isLifted = true
                }
            })
        } else {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = 1.0
            })
        }
        
    }
    
    func didChangeText() {
        
    }
    
    func didEndChangeText() {
        
        if self.isLifted && self.text.isEmpty {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                
                self.placeholderLabel.alpha = self.placeholderAlphaBefore
                self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x / self.scaleCoeff, self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0)
                self.placeholderLabel.transform = CGAffineTransformIdentity
                
                self.underlineView.alpha = self.underLineAlpha
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.isLifted = false
                    }
            })
        } else {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = self.underLineAlpha
            })
        }
        
    }
    
    // MARK: - Dealloc
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
