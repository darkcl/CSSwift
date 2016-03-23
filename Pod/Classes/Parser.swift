//
//  Parser
//  Pods
//
//  Created by Yeung Yiu Hung on 23/3/16.
//
//

import JavaScriptCore

public class Parser: NSObject {
    var cssJs: JSContext!
    
    public func testJS() {
        cssJs = JSContext()
        let podBundle = NSBundle(forClass: self.classForCoder)
        
        if let bundleURL = podBundle.URLForResource("CSSwift", withExtension: "bundle") {
            
            if let bundle = NSBundle(URL: bundleURL) {
                
                let cssJsPath = bundle.pathForResource("css", ofType: "js")
                do{
                    let content = try String(contentsOfFile: cssJsPath!)
                    cssJs.evaluateScript(content)
                }
                catch {}
            }else {
                assertionFailure("Could not load the bundle")
            }
            
        }else {
            assertionFailure("Could not create a path to the bundle")
        }
        
        cssJs.evaluateScript("var cssString = ' .someSelector { margin:40px 10px; padding:5px}';")
        cssJs.evaluateScript("var parser = new cssjs();")
        
        
        let tripleNum: JSValue = cssJs.evaluateScript("JSON.stringify(parser.parseCSS(cssString))")
        
        print(tripleNum)
    }
}
