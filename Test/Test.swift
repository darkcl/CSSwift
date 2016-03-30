import XCTest
import CSSwift

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
    
    func expectedResultForTestCase(testCase: String!) throws -> [CSSModel]!{
        let testCase = testingInput[testCase] as! [String: AnyObject]
        var testingOutput: [CSSModel]! = [CSSModel]()
        let jsonString = testCase["output"] as! String
        let outputDict = try NSJSONSerialization.JSONObjectWithData(jsonString.dataUsingEncoding(NSUTF8StringEncoding)! , options: [.AllowFragments]) as! [AnyObject]
        for dict in outputDict {
            testingOutput.append(CSSModel(infoDict: dict as! [String: AnyObject]))
        }
        
        return testingOutput
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingEmpty() {
        let result = testingParser.parseCSS("");
        
        XCTAssertEqual(result.count, 0)
    }
    
    func testParsingUrlValueCss() {
        let simpleCssTestCase = testingInput["urlTestingCss"] as! [String: String]
        let result = testingParser.parseCSS(simpleCssTestCase["input"]!);
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel! = result[0]
        XCTAssertEqual(model.selector, ".someClass")
        
        let firstRule: CSSRuleModel = model.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule.ruleName, "someDirective")
        
        let firstComp = firstRule.ruleComponents[0] as! String
        
        XCTAssertEqual(firstComp.isUrl, true)
        XCTAssertEqual(firstComp, "http://google.com")
    }
    
    func testParsingUrlFailedValueCss() {
        let simpleCssTestCase = testingInput["urlTestingFailCss"] as! [String: String]
        let result = testingParser.parseCSS(simpleCssTestCase["input"]!);
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel! = result[0]
        XCTAssertEqual(model.selector, ".someClass")
        
        let firstRule: CSSRuleModel = model.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule.ruleName, "someDirective")
        
        let firstComp = firstRule.ruleComponents[0] as! String
        
        XCTAssertEqual(firstComp.isUrl, false)
        XCTAssertEqual(firstComp, "url(http://google.com")
    }
    
    func testParsingSimpleCSS() {
        let simpleCssTestCase = testingInput["veryBasicCSS"] as! [String: String]
        let result = testingParser.parseCSS(simpleCssTestCase["input"]!);
        var expectedResult: [CSSModel]!
        do{
            expectedResult = try expectedResultForTestCase("veryBasicCSS")
        }catch{
            XCTFail("Should not fail")
        }
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testParsingSimpleCSSWithLineBreak() {
        let simpleCssTestCase = testingInput["basicCSS"] as! [String: String]
        let result = testingParser.parseCSS(simpleCssTestCase["input"]!);
        
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
        let result = testingParser.parseCSS(simpleCssTestCase["input"]!);
        
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
