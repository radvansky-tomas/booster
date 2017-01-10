//
//  Helpers.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

enum InvestorType:Int {
    case Defensive = 0
    case Conservative = 1
    case Balanced = 2
    case BalancedGrowth = 3
    case Growth = 4
    case AggressiveGrowth = 5
    
    static var count: Int { return InvestorType.AggressiveGrowth.hashValue + 1}
    
    func getDescription()->String
    {
        switch self {
        case .Defensive:
            return "Defensive"
        case .Conservative:
            return "Conservative"
        case .Balanced:
            return "Balanced"
        case .BalancedGrowth:
            return "Balanced Growth"
        case .Growth:
            return "Growth"
        case .AggressiveGrowth:
            return "Aggressive Growth"
        }
    }
    
    static func getTypeByScore(score:Int)->InvestorType
    {
        if score <= 12
        {
            return .Defensive
        }
        else if score <= 20
        {
            return .Conservative
        }
        else if score <= 29
        {
            return .Balanced
        }
        else if score <= 37
        {
            return .BalancedGrowth
        }
        else if score <= 44
        {
            return .Growth
        }
        else
        {
            return .AggressiveGrowth
        }
    }
    
    static func getType(index:Int)->InvestorType
    {
        switch index {
        case 0:
            return .Defensive
        case 1:
            return .Conservative
        case 2:
            return .Balanced
        case 3:
            return .BalancedGrowth
        case 4:
            return .Growth
        case 5:
            return .AggressiveGrowth
        default:
            return .Defensive
        }
    }
}

class Helpers: NSObject {
    
    class func attributedSizedString(input:String, fontSize:CGFloat)->NSAttributedString
   {
    let style = NSMutableParagraphStyle()
    style.lineBreakMode = .byWordWrapping
    
    let attrs:[String:Any] = [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize),NSParagraphStyleAttributeName:style]
    let result:NSAttributedString = NSAttributedString(string: input, attributes: attrs)
    
    return result
    }
}
