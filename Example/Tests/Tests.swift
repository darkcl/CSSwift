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
        // This is an example of a functional test case.
        
        let aParser: CSSwift.Parser! = CSSwift.Parser()
        let result = aParser.paresCSS(" .someSelector { margin:40px 10px; padding:5px}");
        XCTAssertNotNil(result)
    }
    
}
