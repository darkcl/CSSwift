//
//  Parser
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import JavaScriptCore


public class CSSParser: NSObject {
    var cssJs: JSContext!
    var cssImportStatement: [String]!
    var cssKeyframeStatements: [String]!
    
    let cssRegex: String! = "([\\s\\S]*?){([\\s\\S]*?)}"
    let cssMediaQueryRegex: String! = "((@media [\\s\\S]*?){([\\s\\S]*?}\\s*?)})"
    let cssKeyframeRegex: String! = "((@.*?keyframes [\\s\\S]*?){([\\s\\S]*?}\\s*?)})"
    let combinedCSSRegex: String! = "((\\s*?(?:\\/\\*[\\s\\S]*?\\*\\/)?\\s*?@media[\\s\\S]*?){([\\s\\S]*?)}\\s*?})|(([\\s\\S]*?){([\\s\\S]*?)})" //to match css & media queries together
    let cssCommentsRegex: String! = "(\\/\\*[\\s\\S]*?\\*\\/)";
    let cssImportStatementRegex: String! = "@import .*?;"
    
    func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [])
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                                                options: [], range: NSMakeRange(0, nsString.length))
            return results.map { nsString.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func replaceForRegexInText(regex: String!, text: String!, replaceText: String!) -> String! {
        let nsString = text as NSString
        let results = nsString.stringByReplacingOccurrencesOfString(text, withString: replaceText, options: [.RegularExpressionSearch, .CaseInsensitiveSearch], range: NSRange(location: 0, length: nsString.length))
        return results
    }
    
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
