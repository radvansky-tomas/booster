//
//  ALLocalizableTextField.swift
//  entreinfidele
//
//  Created by Tomas Radvansky on 02/02/2015.
//  Copyright (c) 2015 Tomas Radvansky. All rights reserved.
//

import UIKit

@IBDesignable class ALLocalizableTextField: UITextField {
    // Flag for InterfaceBuilder
    var isInterfaceBuilder: Bool = false
    override func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
    }
    
    @IBInspectable
    var placeholderLocalizeString:String = "" {
        didSet {
            if !self.isInterfaceBuilder {
                #if TARGET_INTERFACE_BUILDER
                    let bundle = Bundle(for: type(of: self))
                    self.placeholder = bundle.localizedString(forKey: self.placeholderLocalizeString, value:"", table: nil)
                #else
                    self.placeholder = NSLocalizedString(self.placeholderLocalizeString, comment:"");
                #endif
            }
        }
    }
    
    @IBInspectable
    var cornerRadius:CGFloat = 0.0 {
        didSet {
            if !self.isInterfaceBuilder {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    @IBInspectable
    var placeholderOffset:CGFloat = 0.0 {
        didSet {
            if !self.isInterfaceBuilder {
                self.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    var borderColor:UIColor = UIColor.darkGray {
        didSet {
            if !self.isInterfaceBuilder {
                self.layer.borderColor = borderColor.cgColor
            }
        }
    }
    
    @IBInspectable
    var borderWidth:CGFloat = 0.0 {
        didSet {
            if !self.isInterfaceBuilder {
                self.layer.borderWidth = borderWidth
            }
        }
    }

    
    @IBInspectable
    var palceholderColor:UIColor = UIColor.lightGray {
        didSet {
            if !self.isInterfaceBuilder {
                #if TARGET_INTERFACE_BUILDER
                    let bundle = Bundle(for: type(of: self))
                    let textFontAttributes: [String: AnyObject] = [
                        NSForegroundColorAttributeName : palceholderColor
                    ]
                    self.attributedPlaceholder = NSAttributedString(string: self.placeholder.safeValue, attributes: textFontAttributes)
                #else
                    let textFontAttributes: [String: AnyObject] = [
                        NSForegroundColorAttributeName : palceholderColor
                    ]
                    self.attributedPlaceholder = NSAttributedString(string: self.placeholder.safeValue, attributes: textFontAttributes)
                #endif
            }
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var newRect:CGRect = bounds
        newRect.origin.x += self.placeholderOffset
        newRect.size.width -= self.placeholderOffset
        return newRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var newRect:CGRect = bounds
        newRect.origin.x += self.placeholderOffset
        newRect.size.width -= self.placeholderOffset
        return newRect
    }
    
}
