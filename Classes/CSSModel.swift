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

extension String {
    
    func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.startIndex.advancedBy(aRange.location)
        let e = self.startIndex.advancedBy(aRange.location + aRange.length)
        return s..<e
    }
    var ns : NSString {return self as NSString}
    subscript (aRange: NSRange) -> String? {
        get {return self.substringWithRange(self.rangeFromNSRange(aRange))}
    }
    
    func toUrl() throws -> String {
        let s = self
        let regex = try NSRegularExpression(pattern: "(?:\\(['|\"]?)(.*?)(?:['|\"]?\\))", options: [])
        let matches = regex.matchesInString(s, options:[], range:NSMakeRange(0, s.ns.length))
        
        if (matches.count != 1) {
            return self
        }else if (matches[0].numberOfRanges != 2) {
            return self
        }
        
        return s.substringWithRange(rangeFromNSRange(matches[0].rangeAtIndex(1)))
    }
}

public class CSSRuleModel: NSObject {
    public var ruleName: String!
    public var ruleContent: String!
    public var ruleComponents: [AnyObject]!
    
    func parseComp(comp: String!) throws -> AnyObject! {
        if comp.hasPrefix("url") {
            return try comp.toUrl()
        }else{
            return comp
        }
    }
    
    convenience init(name: String!, content: String!) {
        self.init()
        
        ruleName = name
        ruleContent = content
        ruleComponents = [AnyObject]()
        
        let comp = ruleContent.componentsSeparatedByString(" ")
        for compStr in comp {
            do{
                ruleComponents.append(try parseComp(compStr))
            }catch{
                ruleComponents.append(compStr)
            }
            
        }
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        guard let rhs = object as? CSSRuleModel else {
            return false
        }
        let lhs = self
        
        var compentEqual = (lhs.ruleComponents.count == rhs.ruleComponents.count)
        if compentEqual {
            for obj1 in lhs.ruleComponents {
                for obj2 in rhs.ruleComponents {
                    if !(obj1.isEqual(obj2)) {
                        compentEqual = false
                    }
                }
            }
        }
        
        return (lhs.ruleName == rhs.ruleName &&
            lhs.ruleContent == rhs.ruleContent && compentEqual)
    }
}
