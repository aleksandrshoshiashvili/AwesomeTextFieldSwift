//
//  AwesomeTextField.swift
//  AwesomeTextField
//
//  Created by MacBookPro on 22.07.15.
//  Copyright (c) 2015 MacBookPro. All rights reserved.
//

import UIKit

@IBDesignable
open class AwesomeTextField: UITextField {

    @IBInspectable var underLineWidth : CGFloat = 2.0
    @IBInspectable var underLineColor : UIColor = UIColor.black
    @IBInspectable var underLineAlphaBefore : CGFloat = 0.5
    @IBInspectable var underLineAlphaAfter : CGFloat = 1

    @IBInspectable var placeholderTextColor : UIColor = UIColor.gray
    @IBInspectable var animationDuration : TimeInterval = 0.35

    let scaleCoeff : CGFloat = 0.75
    let textInsetX : CGFloat = 1.5
    let placeholderAlphaAfter : CGFloat = 0.85
    let placeholderAlphaBefore : CGFloat = 0.5

    var placeholderLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var underlineView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var isLifted = false

    override open func draw(_ rect: CGRect) {
        super.draw(rect)

        self.drawLine()

        NotificationCenter.default.addObserver(self, selector: #selector(didBeginChangeText), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeText), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
    }

    func drawLine() {
        let underLine = UIView(frame:CGRect(x: 0, y: frame.size.height - underLineWidth, width: frame.size.width, height: underLineWidth))

        underLine.backgroundColor = underLineColor
        underLine.alpha = underLineAlphaBefore

        underlineView = underLine
        self.addSubview(underlineView)
    }

    override open func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)

        placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: underLineWidth, width: rect.size.width, height: font!.pointSize))
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2)
        placeholderLabel.text = self.placeholder
        self.placeholder = nil

        placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)

        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaBefore

        self.addSubview(placeholderLabel)
        self.bringSubview(toFront: placeholderLabel)
    }

    func drawPlaceholderIfTextExistInRect(rect: CGRect) {
        placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: underLineWidth*2, width: rect.size.width, height: self.font!.pointSize))
        placeholderLabel.transform = CGAffineTransform(scaleX: scaleCoeff, y: scaleCoeff)
        placeholderLabel.center = CGPoint(x: placeholderLabel.center.x * scaleCoeff, y: 0 + placeholderLabel.frame.size.height)
        placeholderLabel.text = self.placeholder
        self.placeholder = nil

        placeholderLabel.font = UIFont(name: self.font!.fontName, size: self.font!.pointSize)

        placeholderLabel.textColor = placeholderTextColor
        placeholderLabel.alpha = placeholderAlphaAfter
        isLifted = true

        self.addSubview(placeholderLabel)
        self.bringSubview(toFront: placeholderLabel)
    }

    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect)

        if self.placeholder != nil {
            drawPlaceholderIfTextExistInRect(rect: rect)
        }

        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: self.textInsetX, dy: insetForY)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insetForY = self.underLineWidth + 2.0
        self.textAlignment = .left
        self.contentVerticalAlignment = .bottom
        return bounds.insetBy(dx: self.textInsetX, dy: insetForY)
    }

    // MARK: - Delegate

    func didBeginChangeText() {
        if !self.isLifted {
            UIView.animate(withDuration: animationDuration, animations: {
                self.placeholderLabel.transform = CGAffineTransform(scaleX: self.scaleCoeff, y: self.scaleCoeff)
                self.placeholderLabel.alpha = self.placeholderAlphaAfter
                self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x * self.scaleCoeff, y: 0 + self.placeholderLabel.frame.size.height)
                self.underlineView.alpha = self.underLineAlphaAfter
            }, completion: { (finished) in
                if finished {
                    self.isLifted = true
                }
            })
        }
        else {
            UIView.animate(withDuration: animationDuration, animations: {
                self.underlineView.alpha = self.underLineAlphaAfter
            })
        }
    }

    func didChangeText() {
        if self.isLifted {
            if self.text?.characters.count == 0 {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.placeholderLabel.alpha = self.placeholderAlphaBefore
                    self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x / self.scaleCoeff, y: self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0)
                    self.placeholderLabel.transform = CGAffineTransform.identity
                    self.underlineView.alpha = self.underLineAlphaBefore
                }, completion: { (finished) in
                    if finished {
                        self.isLifted = false
                    }
                })
            }
        }
        else {
            if (self.text?.characters.count)! > 0 {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.placeholderLabel.transform = CGAffineTransform(scaleX: self.scaleCoeff, y: self.scaleCoeff)
                    self.placeholderLabel.alpha = self.placeholderAlphaAfter
                    self.placeholderLabel.center = CGPoint(x: self.placeholderLabel.center.x * self.scaleCoeff, y: 0 + self.placeholderLabel.frame.size.height)
                    self.underlineView.alpha = self.underLineAlphaAfter
                }, completion: { (finished) in
                    if finished {
                        self.isLifted = true
                    }
                })
            } else {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.underlineView.alpha = self.underLineAlphaBefore
                })
            }
        }

    }

    // MARK: - Dealloc

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
