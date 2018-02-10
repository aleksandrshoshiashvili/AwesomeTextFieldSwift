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
    
    let placeholderRect = CGRect(x: rect.origin.x,
                                 y: underLineWidth,
                                 width: rect.size.width,
                                 height: font.pointSize)
    placeholderLabel = UILabel(frame: placeholderRect)
    placeholderLabel.center = CGPoint(x: placeholderLabel.center.x,
                                      y: frame.size.height - underlineView.frame.size.height - placeholderLabel.frame.size.height / 2)
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
    
    let placeholderRect = CGRect(x: rect.origin.x,
                                 y: underLineWidth * 2,
                                 width: rect.size.width,
                                 height: font.pointSize)
    placeholderLabel = UILabel(frame: placeholderRect)
    placeholderLabel.transform = CGAffineTransform(scaleX: scaleCoeff, y: scaleCoeff)
    placeholderLabel.center = CGPoint(x: placeholderLabel.center.x * scaleCoeff,
                                      y: placeholderLabel.frame.size.height)
    placeholderLabel.text = placeholder
    placeholder = nil
    
    placeholderLabel.font = UIFont(name: font.fontName, size: font.pointSize)
    
    placeholderLabel.textColor = placeholderTextColor
    placeholderLabel.alpha = placeholderAlphaAfter
    isLifted = true
    
    placeholderLabelMinCenter = placeholderLabel.center.x
    
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
      let newCenterX = max(placeholderLabelMinCenter, placeholderLabel.center.x * scaleCoeff)
      let newCenter = CGPoint(x: newCenterX,
                              y: placeholderLabel.frame.size.height)
      animatePlaceholder(withNewCenter: newCenter,
                         scaleCoeff: scaleCoeff,
                         newAlpha: placeholderAlphaAfter,
                         underlineAlpha: underLineAlphaAfter,
                         isLiftedAfterFinishing: true)
    } else {
      animateUnderline(withAlpha: underLineAlphaAfter)
    }
  }
  
  @objc func didChangeText() {
    if isLifted {
      if text?.count == 0 {
        let newCenterX = min(self.placeholderLabelMinCenter / self.scaleCoeff, self.placeholderLabel.center.x / self.scaleCoeff)
        let newCenterY = self.frame.size.height - self.underlineView.frame.size.height - self.placeholderLabel.frame.size.height / 2.0 - 2.0
        let newCenter = CGPoint(x: newCenterX, y: newCenterY)
        
        animatePlaceholder(withNewCenter: newCenter,
                           scaleCoeff: 1,
                           newAlpha: placeholderAlphaBefore,
                           underlineAlpha: underLineAlphaBefore,
                           isLiftedAfterFinishing: false)
      }
    } else {
      if text?.count != 0 {
        let newCenterX = max(placeholderLabelMinCenter, placeholderLabel.center.x * scaleCoeff)
        let newCenter = CGPoint(x: newCenterX,
                                y: placeholderLabel.frame.size.height)
        animatePlaceholder(withNewCenter: newCenter,
                           scaleCoeff: scaleCoeff,
                           newAlpha: placeholderAlphaAfter,
                           underlineAlpha: underLineAlphaAfter,
                           isLiftedAfterFinishing: true)
      } else {
        animateUnderline(withAlpha: underLineAlphaBefore)
      }
    }
    
  }
  
  func animateUnderline(withAlpha alpha: CGFloat) {
    UIView.animate(withDuration: animationDuration, animations: {
      self.underlineView.alpha = alpha
    })
  }
  
  func animatePlaceholder(withNewCenter newCenter: CGPoint,
                          scaleCoeff: CGFloat,
                          newAlpha: CGFloat,
                          underlineAlpha: CGFloat,
                          isLiftedAfterFinishing: Bool) {
    UIView.animate(withDuration: animationDuration, animations: {
      self.placeholderLabel.transform(withCoeff: scaleCoeff, andMoveCenterToPoint: newCenter)
      self.placeholderLabel.alpha = newAlpha
      self.underlineView.alpha = underlineAlpha
    }, completion: isLiftedCompletion(withNewValue: isLiftedAfterFinishing))
  }
  
  // MARK: - Private
  
  private func isLiftedCompletion(withNewValue value: Bool) -> ((Bool) -> Void)? {
    return { (finished) in
      if finished {
        self.isLifted = value
      }
    }
  }
  
  // MARK: - Dealloc
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
}

extension UIView {
  
  func transform(withCoeff coeff: CGFloat, andMoveCenterToPoint center: CGPoint) {
    let transform = CGAffineTransform(scaleX: coeff, y: coeff)
    self.transform = transform
    self.center = center
  }
  
}
