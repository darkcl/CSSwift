import UIKit
import XCTest
import CSSwift

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingCSS() {
        
        let aParser: CSSParser! = CSSParser()
        let result = aParser.paresCSS(" .someSelector { margin:40px 10px; padding:5px}");
        
        print(result)
        
        XCTAssertEqual(result.count, 1)
        
        let model: CSSModel? = result[0]
        XCTAssertEqual(model?.selector, ".someSelector")
        
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.rules?.count, 2)
        
        let firstRule: CSSRuleModel? = model?.rules![0]
        XCTAssertNotNil(firstRule)
        XCTAssertEqual(firstRule?.ruleName, "margin")
        XCTAssertEqual(firstRule?.ruleContent, "40px 10px")
        
    }
    
}
