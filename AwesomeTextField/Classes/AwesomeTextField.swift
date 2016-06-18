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
    @IBInspectable var underLineAlphaBefore : CGFloat = 0.5
    @IBInspectable var underLineAlphaAfter : CGFloat = 1
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AwesomeTextField.didBeginChangeText), name: UITextFieldTextDidBeginEditingNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AwesomeTextField.didChangeText), name: UITextFieldTextDidChangeNotification, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AwesomeTextField.didEndChangeText), name: UITextFieldTextDidEndEditingNotification, object: self)
        
    }
    
    func drawLine() {
        
        let underLine = UIView(frame:CGRectMake(0, self.frame.size.height - self.underLineWidth, self.frame.size.width, self.underLineWidth))
        
        underLine.backgroundColor = self.underLineColor
        underLine.alpha = self.underLineAlphaBefore
        
        self.underlineView = underLine
        
        self.addSubview(self.underlineView)
        
    }
    
    override func drawPlaceholderInRect(rect: CGRect) {
        
        super.drawPlaceholderInRect(rect)
        
        self.placeholderLabel = UILabel(frame: CGRectMake(rect.origin.x, self.underLineWidth, rect.size.width, self.font!.pointSize))
        self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x, self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaBefore
        
        self.addSubview(self.placeholderLabel)
        self.bringSubviewToFront(self.placeholderLabel)
        
    }
    
    func drawPlaceholderIfTextExistInRect(rect: CGRect) {
        
        self.placeholderLabel = UILabel(frame: CGRectMake(rect.origin.x, self.underLineWidth, rect.size.width, self.font!.pointSize))
        self.placeholderLabel.transform = CGAffineTransformMakeScale(self.scaleCoeff, self.scaleCoeff)
        self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x * self.scaleCoeff, 0 + self.placeholderLabel.frame.size.height)
        self.placeholderLabel.text = self.placeholder
        self.placeholder = nil
        
        self.placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)
        
        self.placeholderLabel.textColor = self.placeholderTextColor
        self.placeholderLabel.alpha = self.placeholderAlphaAfter
        self.isLifted = true
        
        self.addSubview(self.placeholderLabel)
        self.bringSubviewToFront(self.placeholderLabel)
        
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(rect)
        
        if self.placeholder != nil {
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
                
                self.underlineView.alpha = self.underLineAlphaAfter
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.isLifted = true
                    }
            })
        } else {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = self.underLineAlphaAfter
            })
        }
        
    }
    
    func didChangeText() {
        
    }
    
    func didEndChangeText() {
        
        if self.isLifted && self.text!.isEmpty {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                
                self.placeholderLabel.alpha = self.placeholderAlphaBefore
                self.placeholderLabel.center = CGPointMake(self.placeholderLabel.center.x / self.scaleCoeff, self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0)
                self.placeholderLabel.transform = CGAffineTransformIdentity
                
                self.underlineView.alpha = self.underLineAlphaBefore
                
                }, completion: { (finished) -> Void in
                    if finished {
                        self.isLifted = false
                    }
            })
        } else {
            UIView.animateWithDuration(self.animationDuration, animations: { () -> Void in
                self.underlineView.alpha = self.underLineAlphaBefore
            })
        }
        
    }
    
    // MARK: - Dealloc
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
