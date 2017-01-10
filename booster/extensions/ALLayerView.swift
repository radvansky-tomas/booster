//
//  ALLayerView.swift
//  entreinfidele
//
//  Created by Tomas Radvansky on 11/02/2015.
//  Copyright (c) 2015 Tomas Radvansky. All rights reserved.
//

import UIKit
@IBDesignable class ALLayerView: UIView {
    // Flag for InterfaceBuilder
    var isInterfaceBuilder: Bool = false
    override func prepareForInterfaceBuilder() {
        self.isInterfaceBuilder = true
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
    var cornerRadius:CGFloat = 0.0 {
        didSet {
            if !self.isInterfaceBuilder {
                self.layer.cornerRadius = cornerRadius
            }
        }
    }
    
    @IBInspectable
    var rounded:Bool = false {
        didSet {
            if !self.isInterfaceBuilder {
                if rounded
                {
                    self.layer.cornerRadius = self.frame.size.width / 2
                    self.layer.masksToBounds = true
                }
                else
                {
                    self.layer.cornerRadius = 0
                    self.layer.masksToBounds = false
                }
            }
        }
    }
}
