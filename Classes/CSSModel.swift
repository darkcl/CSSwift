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
    public var comments: String?
    public var type: String?
    public var selector: String!
    public var styles: String?
    
    public convenience init(infoDict:[String: AnyObject]!) {
        self.init()
        
        print(infoDict)
        rules = [CSSRuleModel]()
        for dict in (infoDict["rules"] as? [Dictionary<String,String>])! {
            
            rules.append(CSSRuleModel(name: dict["directive"], content: dict["value"]))
        }
        selector = infoDict["selector"]! as? String
        comments = infoDict["comments"] as? String
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? CSSModel else {
            return false
        }
        let lhs = self
        
        return (lhs.styles == rhs.styles &&
            lhs.comments == rhs.comments &&
            lhs.type == rhs.type &&
            lhs.selector == rhs.selector &&
            lhs.styles == rhs.styles &&
            lhs.rules == rhs.rules)
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
    
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? CSSRuleModel else {
            return false
        }
        let lhs = self
        
        return (lhs.ruleName == rhs.ruleName &&
            lhs.ruleContent == rhs.ruleContent)
    }
}
