//
//  FundObject.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation

struct AssetData {
    var title:String?
    var value:Double?
}

struct FundAssets {
    var growth:[AssetData]?
    var income:[AssetData]?
}

class FundObject: NSObject {
    var title:String?
    var info:[String]?
    var assets:FundAssets?
    
    init(plist:[String:AnyObject]) {
        print("parsing:\(plist)")
        self.title = plist["Title"] as? String
        self.info = plist["Info"] as? [String]
        if let assetsData:[String:AnyObject] = plist["Assets"] as? [String:AnyObject]
        {
            //Parse growth
            var growthParsed:Array<AssetData> = []
            var incomeParsed:Array<AssetData> = []
            
            if let growthData:Array<[String:AnyObject]> = assetsData["Growth"] as? Array<[String:AnyObject]>
            {
                for entry in growthData
                {
                    growthParsed.append(AssetData(title: entry["Title"] as? String, value: entry["Value"] as? Double))
                }
            }
            
            //parse income
            if let incomeData:Array<[String:AnyObject]> = assetsData["Income"] as? Array<[String:AnyObject]>
            {
                for entry in incomeData
                {
                    incomeParsed.append(AssetData(title: entry["Title"] as? String, value: entry["Value"] as? Double))
                }
            }
            
            self.assets = FundAssets(growth: growthParsed, income: incomeParsed)
        }
    }
}
