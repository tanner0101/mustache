import XCTest
@testable import Mustache

final class MustacheTests: XCTestCase {
    func testHello() throws {
        let result = try MustacheRenderer().render(
            template: "Hello, {{name}}!",
            data: ["name": "Vapor"]
        )
        XCTAssertEqual(result, "Hello, Vapor!")
    }

    func testInvalidSyntax() throws {
        do {
            _ = try MustacheRenderer().render(
                template: "Hello, {{name}!",
                data: ["name": "Vapor"]
            )
            XCTFail("should have thrown")
        } catch let error as MustacheError {
            print(error)
        }
    }

    func testSectionValue() throws {
        let result = try MustacheRenderer().render(
            template: "{{#repo}}<b>{{name}}</b>{{/repo}}",
            data: ["repo": "false"]
        )
        XCTAssertEqual(result, "")
    }

    func testSectionDictionary() throws {
        let result = try MustacheRenderer().render(
            template: "{{#repo}}<b>{{name}}</b>{{/repo}}",
            data: ["repo": ["name": "vapor/vapor"]]
        )
        XCTAssertEqual(result, "<b>vapor/vapor</b>")
    }

    func testSectionArray() throws {
        let result = try MustacheRenderer().render(
            template: "{{#repo}}<b>{{name}}</b>{{/repo}}",
            data: ["repo": [["name": "vapor/vapor"],["name": "vapor/fluent"]]]
        )
        XCTAssertEqual(result, "<b>vapor/vapor</b><b>vapor/fluent</b>")
    }
}
