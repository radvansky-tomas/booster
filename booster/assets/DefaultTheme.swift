//
//  default_theme.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class DefaultTheme {
    enum CustomColor:String {
        case backgroundColor = "ffffff"
        case primaryColor = "72b0e3"
        case primaryColorDark = "007fc4"
        case secondaryColor = "c8e69e"
        case secondaryColorDark = "c8e99e"
        case accentColor = "f8e38b"
        case accentColorDark = "ffdd55"
    }
    
    class func Color(color:CustomColor)->UIColor
    {
        return UIColor(hexString: color.rawValue)
    }
    
    class func Font(size:CGFloat)->UIFont
    {
        return UIFont(name: "Circulartt-Book", size: size)!
    }
}
