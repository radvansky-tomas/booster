//
//  ClosureSelector.swift
//  icargonaut
//
//  Created by Tomas Radvansky on 10/11/2016.
//  Copyright © 2016 Tomas Radvansky. All rights reserved.
//

import Foundation
//Parameter is the type of parameter passed in the selector
public class ClosureSelector<Parameter> {
    
    public let selector : Selector
    private let closure : ( Parameter ) -> ()
    
    init(withClosure closure : @escaping ( Parameter ) -> ()){
        self.selector = #selector(ClosureSelector.target(param:))
        self.closure = closure
    }
    
    // Unfortunately we need to cast to AnyObject here
    @objc func target( param : AnyObject) {
        closure(param as! Parameter)
    }
}
