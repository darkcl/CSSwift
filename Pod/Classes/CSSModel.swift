//
//  CSSModel.swift
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import Foundation

enum CSSProperties : String {
    case Color = "color"
    case Opacity = "opacity"
    
    static let allProperties = [Color, Opacity]
}

public class CSSModel: NSObject {
    public var rules: [CSSRuleModel]!
    public var type: String!
    public var selector: String!
    
    convenience init(infoDict:[String: AnyObject]!) {
        self.init()
        
        print(infoDict)
        rules = [CSSRuleModel]()
        for dict in (infoDict["rules"] as? [Dictionary<String,String>])! {
            
            rules.append(CSSRuleModel(name: dict["directive"], content: dict["value"]))
        }
        selector = infoDict["selector"]! as? String
    }
}

public class CSSRuleModel: NSObject {
    public var ruleName: String!
    public var ruleContent: String!
    
    convenience init(name: String!, content: String!) {
        self.init()
        
        ruleName = name
        ruleContent = content
    }
}
