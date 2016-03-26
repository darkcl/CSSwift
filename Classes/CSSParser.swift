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
    
    public func parseCSS(cssString: String) -> [CSSModel]! {
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
