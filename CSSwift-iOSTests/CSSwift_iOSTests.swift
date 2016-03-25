import XCTest
import CSSwiftiOS

class Tests: XCTestCase {
    var testingParser: CSSParser!
    var testingInput: [String: AnyObject]!
    override func setUp() {
        super.setUp()
        testingParser = CSSParser()
        
        let testBundle = NSBundle(forClass: self.classForCoder)
        
        let jsonData = NSData(contentsOfFile: testBundle.pathForResource("Test", ofType: "json")!)
        
        do{
            testingInput = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: [.AllowFragments]) as! [String : AnyObject]
        }catch{
            
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingSimpleCSS() {
        let simpleCssTestCase = testingInput["veryBasicCSS"] as! [String: String]
        let result = testingParser.paresCSS(simpleCssTestCase["input"]!);
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel! = result[0]
        XCTAssertEqual(model.selector, ".someClass")
        
        XCTAssertNotNil(model)
        XCTAssertEqual(model.rules?.count, 1)
        
        let firstRule: CSSRuleModel = model.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule.ruleName, "someDirective")
        XCTAssertEqual(firstRule.ruleContent, "someValue")
    }
    
    func testParsingSimpleCSSWithLineBreak() {
        let simpleCssTestCase = testingInput["basicCSS"] as! [String: String]
        let result = testingParser.paresCSS(simpleCssTestCase["input"]!);
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel! = result[0]
        XCTAssertEqual(model.selector, "html")
        
        let firstRule: CSSRuleModel = model.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule.ruleName, "color")
        XCTAssertEqual(firstRule.ruleContent, "black")
    }
    
    func testParsingSimpleCSSWithComment() {
        let simpleCssTestCase = testingInput["basicCSS2"] as! [String: String]
        let result = testingParser.paresCSS(simpleCssTestCase["input"]!);
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel! = result[0]
        XCTAssertEqual(model.selector, "html")
        XCTAssertEqual(model.comments, "/*\nSome Comments\nBaby \n*/")
        
        let firstRule: CSSRuleModel = model.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule.ruleName, "color")
        XCTAssertEqual(firstRule.ruleContent, "black")
    }
}
