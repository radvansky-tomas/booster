//
//  QuestionnaireObject.swift
//  booster
//
//  Created by Tomas Radvansky on 10/01/2017.
//  Copyright © 2017 Tomas Radvansky. All rights reserved.
//

import Foundation

struct Answer {
    var text:String?
    var value:Int?
}

class QuestionnaireObject: NSObject {
    var id:Int?
    var question:String?
    var answers:Array<Answer>?
    
    init(plist:[String:AnyObject]) {
        print("parsing:\(plist)")
        question = plist["Question"] as? String
        id = plist["ID"] as? Int
        if let answersData:Array<[String:AnyObject]> = plist["Answers"] as? Array<[String:AnyObject]>
        {
            //Parse answers
            var answersParsed:Array<Answer> = []
            for entry in answersData
            {
                answersParsed.append(Answer(text: entry["Answer"] as? String, value: entry["Value"] as? Int))
            }
            self.answers = answersParsed
        }
    }
}
