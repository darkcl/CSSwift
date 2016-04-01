//
//  CSSModel.swift
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import Foundation
import ObjectiveC

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

enum StringParsing: ErrorType {
    case CannotParseColor
    case CannotParseUrl
    case CannotFindSpecial
}

public extension String {
    private struct AssociatedKeys {
        static var CSSisUrlAssociationKey :UInt8 = 0
        static var CSSisColorAssociationKey :UInt8 = 0
    }
    
    public var isColor: Bool! {
        get {
            guard let result = objc_getAssociatedObject(self, &AssociatedKeys.CSSisColorAssociationKey) as? Bool else{
                return false
            }
            return result
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.CSSisColorAssociationKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    public var isUrl: Bool! {
        get {
            guard let result = objc_getAssociatedObject(self, &AssociatedKeys.CSSisUrlAssociationKey) as? Bool else{
                return false
            }
            return result
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.CSSisUrlAssociationKey,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    func rangeFromNSRange(aRange: NSRange) -> Range<String.Index> {
        let s = self.startIndex.advancedBy(aRange.location)
        let e = self.startIndex.advancedBy(aRange.location + aRange.length)
        return s..<e
    }
    var ns : NSString {return self as NSString}
    subscript (aRange: NSRange) -> String? {
        get {return self.substringWithRange(self.rangeFromNSRange(aRange))}
    }
    
    func toColor() -> [String] {
        do {
            let s = self
            let regex = try NSRegularExpression(pattern: "rgb(a|)(?:\\(['|\"]?)(.*?)(?:['|\"]?\\))", options: [])
            let matches = regex.matchesInString(s, options:[], range:NSMakeRange(0, s.ns.length))
            
            var result = [String]()
            if (matches.count == 0) {
                throw StringParsing.CannotParseColor
            }else{
                for match in matches {
                    if match.numberOfRanges == 3 {
                        var resultStr = s.substringWithRange(rangeFromNSRange(match.rangeAtIndex(2)))
                        resultStr.isColor = true
                        result.append(resultStr)
                    }
                }
                return result
            }
        } catch {
            return [String]()
        }
        
    }
    
    func toUrl() -> [String] {
        do {
            let s = self
            let regex = try NSRegularExpression(pattern: "url(?:\\(['|\"]?)(.*?)(?:['|\"]?\\))", options: [])
            let matches = regex.matchesInString(s, options:[], range:NSMakeRange(0, s.ns.length))
            
            var result = [String]()
            if (matches.count == 0) {
                throw StringParsing.CannotParseUrl
            }else{
                for match in matches {
                    if match.numberOfRanges == 2 {
                        var resultStr = s.substringWithRange(rangeFromNSRange(match.rangeAtIndex(1)))
                        resultStr.isUrl = true
                        result.append(resultStr)
                    }
                }
                return result
            }
        } catch {
            return [String]()
        }
    }
}

public class CSSRuleModel: NSObject {
    public var ruleName: String!
    public var ruleContent: String!
    public var ruleComponents: [AnyObject]!
    
    func parseComp(comp: String!) throws -> [AnyObject]! {
        var result = [String]()
        result.appendContentsOf(comp.toUrl())
        result.appendContentsOf(comp.toColor())
        if result.count == 0 {
            throw StringParsing.CannotFindSpecial
        }
        return result
    }
    
    convenience init(name: String!, content: String!) {
        self.init()
        
        ruleName = name
        ruleContent = content
        ruleComponents = [AnyObject]()
        
        do{
            ruleComponents.appendContentsOf(try parseComp(ruleContent))
        }catch{
            ruleComponents = ruleContent.componentsSeparatedByString(" ")
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
