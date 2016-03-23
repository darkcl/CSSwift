//
//  CSSModel.swift
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import Foundation

class CSSModel: NSObject {
    var rules: [AnyObject]?
    var selector: String?
    
    convenience init(infoDict:[String: AnyObject]!) {
        self.init()
        
        rules = infoDict["rules"]! as? [AnyObject]
        selector = infoDict["selector"]! as? String
    }
}
