import XCTest
@testable import swifttest

final class swifttestTests: XCTestCase {
    func testExample() throws {
      let calc = Calculator()
      guard let result1 = calc.tryParseAndSolveFormula(from: "2+2*10-1") else {
        XCTFail("Could't parse formula")
        return
      }

      guard let result2 = calc.tryParseAndSolveFormula(from: "10+20+30*(20+(5/2))^2/10+0.75") else {
        XCTFail("Could't parse formula")
        return
      }

      XCTAssertEqual(result1, 21)
      XCTAssertEqual(result2, 1549.5)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
