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
  
  @IBInspectable var underLineWidth: CGFloat = 2.0
  @IBInspectable var underLineColor: UIColor = .black
  @IBInspectable var underLineAlphaBefore: CGFloat = 0.5
  @IBInspectable var underLineAlphaAfter: CGFloat = 1
  
  @IBInspectable var placeholderTextColor: UIColor = .gray
  @IBInspectable var animationDuration: TimeInterval = 0.35
  
  let scaleCoeff: CGFloat = 0.75
  let textInsetX: CGFloat = 1.5
  let placeholderAlphaAfter: CGFloat = 0.85
  let placeholderAlphaBefore: CGFloat = 0.5
  
  var placeholderLabel = UILabel(frame: CGRect.zero)
  var placeholderLabelMinCenter: CGFloat = 0.0
  var underlineView = UIView(frame: CGRect.zero)
  var isLifted = false
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    drawLine()
    
    NotificationCenter.default.addObserver(self, selector: #selector(didBeginChangeText), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
    NotificationCenter.default.addObserver(self, selector: #selector(didChangeText), name: NSNotification.Name.UITextFieldTextDidChange, object: self)
  }
  
  func drawLine() {
    let underLine = UIView(frame:CGRect(x: 0, y: frame.size.height - underLineWidth, width: frame.size.width, height: underLineWidth))
    
    underLine.backgroundColor = underLineColor
    underLine.alpha = underLineAlphaBefore
    
    underlineView = underLine
    addSubview(underlineView)
  }
  
  override open func drawPlaceholder(in rect: CGRect) {
    super.drawPlaceholder(in: rect)
    
    guard let font = font else { return }
    
    placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: underLineWidth, width: rect.size.width, height: font.pointSize))
    placeholderLabel.center = CGPoint(x: placeholderLabel.center.x, y: frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2)
    placeholderLabel.text = placeholder
    placeholder = nil
    
    placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
    
    placeholderLabel.textColor = placeholderTextColor
    placeholderLabel.alpha = placeholderAlphaBefore
    
    placeholderLabelMinCenter = placeholderLabel.center.x * scaleCoeff
    
    addSubview(placeholderLabel)
    bringSubview(toFront: placeholderLabel)
  }
  
  func drawPlaceholderIfTextExistInRect(rect: CGRect) {
    guard let font = font else { return }
    
    placeholderLabel = UILabel(frame: CGRect(x: rect.origin.x, y: underLineWidth*2, width: rect.size.width, height: font.pointSize))
    placeholderLabel.transform = CGAffineTransform(scaleX: scaleCoeff, y: scaleCoeff)
    placeholderLabel.center = CGPoint(x: placeholderLabel.center.x * scaleCoeff, y: 0 + placeholderLabel.frame.size.height)
    placeholderLabel.text = placeholder
    placeholder = nil
    
    placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
    
    placeholderLabel.textColor = placeholderTextColor
    placeholderLabel.alpha = placeholderAlphaAfter
    isLifted = true
    
    addSubview(placeholderLabel)
    bringSubview(toFront: placeholderLabel)
  }
  
  override open func drawText(in rect: CGRect) {
    super.drawText(in: rect)
    
    if let _ = placeholder, let textString = text, !textString.isEmpty {
      drawPlaceholderIfTextExistInRect(rect: rect)
    }
    
    textAlignment = .left
    contentVerticalAlignment = .bottom
  }
  
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    let insetForY = underLineWidth + 2.0
    textAlignment = .left
    contentVerticalAlignment = .bottom
    return bounds.insetBy(dx: textInsetX, dy: insetForY)
  }
  
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    let insetForY = underLineWidth + 2.0
    textAlignment = .left
    contentVerticalAlignment = .bottom
    return bounds.insetBy(dx: textInsetX, dy: insetForY)
  }
  
  // MARK: - Delegate
  
  @objc func didBeginChangeText() {
    if !isLifted {
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
  
  @objc func didChangeText() {
    if isLifted {
      if text?.count == 0 {
        UIView.animate(withDuration: animationDuration, animations: {
          self.placeholderLabel.alpha = self.placeholderAlphaBefore
          self.placeholderLabel.center = CGPoint(x: min(self.placeholderLabelMinCenter / self.scaleCoeff, self.placeholderLabel.center.x / self.scaleCoeff), y: self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0)
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
      if text?.count != 0 {
        UIView.animate(withDuration: animationDuration, animations: {
          self.placeholderLabel.transform = CGAffineTransform(scaleX: self.scaleCoeff, y: self.scaleCoeff)
          self.placeholderLabel.alpha = self.placeholderAlphaAfter
          self.placeholderLabel.center = CGPoint(x: max(self.placeholderLabelMinCenter, self.placeholderLabel.center.x * self.scaleCoeff), y: 0 + self.placeholderLabel.frame.size.height)
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
