//
//  Parser
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import JavaScriptCore

//class Regex {
//    let internalExpression: NSRegularExpression
//    let pattern: String
//    
//    init(_ pattern: String) {
//        self.pattern = pattern
//        var error: NSError?
//        self.internalExpression = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions)
//    }
//    
//    func test(input: String) -> Bool {
//        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
//        return matches.count > 0
//    }
//}

public class CSSParser: NSObject {
    var cssJs: JSContext!
    
    func loadCssJs() {
        cssJs = JSContext()
        let podBundle = NSBundle(forClass: self.classForCoder)
        let cssJsPath = podBundle.pathForResource("css", ofType: "js")
        do{
            let content = try String(contentsOfFile: cssJsPath!)
            cssJs.evaluateScript(content)
        }
        catch {}
        
    }
    
    public func paresCSS(cssString: String) -> [CSSModel]! {
        loadCssJs()
        
        cssJs.setObject(cssString, forKeyedSubscript: "cssValue")
        cssJs.evaluateScript("var parser = new cssjs();")
        let cssResult = cssJs.evaluateScript("parser.parseCSS(cssValue)")
        let jsResult = cssResult.toArray()
        var result = Array<CSSModel>();
        guard (jsResult != nil) else{
            return result
        }
        
        for dict in jsResult{
            
            result.append(CSSModel(infoDict: dict as! [String : AnyObject]))
        }
        return result
    }
}