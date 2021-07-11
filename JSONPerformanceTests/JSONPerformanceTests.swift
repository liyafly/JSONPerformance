//
//  JSONPerformanceTests.swift
//  JSONPerformanceTests
//
//  Created by 李亚非 on 2021/7/5.
//

import XCTest
import SwiftyJSON
import ObjectMapper
@testable import JSONPerformance

let count = 100 // 1, 10, 100, 1000, or 10000
let data = airportsJSON(count: count)

class JSONPerformanceTests: XCTestCase {

    override class var defaultPerformanceMetrics: [XCTPerformanceMetric] {
        return [
            XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_WallClockTime"),
            XCTPerformanceMetric(rawValue: "com.apple.XCTPerformanceMetric_TransientHeapAllocationsKilobytes")
        ]
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testPerformanceJSONSerialization() {
        self.measure {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            let airports = json.map{ Airport(json: $0) }
            XCTAssertEqual(airports.count, count)
        }
    }
    
    func testPerformanceSwityJSON() {
        self.measure {
            if let json = try? JSON(data: data) {
                let airports = json.map{ AirportJSON(jsonData: JSON(rawValue: $0) ?? JSON()) }
                XCTAssertEqual(airports.count, count)
            }
        }
    }
    
    func testPerformanceCodable() {
        self.measure {
            let decoder = JSONDecoder()
            let airports = try! decoder.decode([Airport].self, from: data)
            XCTAssertEqual(airports.count, count)
        }
    }
    
    func testPerformanceHandyJSON() {
        self.measure {
            let json = String(data: data, encoding: .utf8)
            let airports = [HandyAirport].deserialize(from: json) ?? []
            XCTAssertEqual(airports.count, count)
        }
    }
    
    func testObjectMapper() {
        self.measure {
                let json = String(data: data, encoding: .utf8) ?? ""
                let objects =  Mapper<ObjectAirport>().mapArray(JSONString: json)
                XCTAssertEqual(objects?.count, count)
            }
        }
}
