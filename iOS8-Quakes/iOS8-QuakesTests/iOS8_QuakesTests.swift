//
//  iOS8_QuakesTests.swift
//  iOS8-QuakesTests
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import XCTest
@testable import iOS8_Quakes

class iOS8_QuakesTests: XCTestCase {

	func testQuakeJSONHowToDebugWithDoCatch() throws {
		
		let decoder = JSONDecoder()
		
		do {
			let quake = try decoder.decode(Quake.self, from: quakeData)
			XCTAssertEqual(1.29, quake.mag, accuracy: 0.01)

		} catch {
			print("Error decoding: \(error)")
			throw error
		}
	}
	
	func testQuakeJSON() throws {
		// Arrange
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .millisecondsSince1970
		// API stores time in milliseconds
		let date = Date(timeIntervalSince1970: 1388620296020 / 1000)
		
		// Act
		let quake = try decoder.decode(Quake.self, from: quakeData)
		
		// Assert
		XCTAssertEqual(1.29, quake.mag, accuracy: 0.001)
		XCTAssertEqual("10km SSW of Idyllwild, CA", quake.place)
		XCTAssertEqual(date, quake.time)
		XCTAssertEqual(-116.7776667, quake.longitude, accuracy: 0.001)
		XCTAssertEqual(33.663333299999998, quake.latitude, accuracy: 0.001)
	}
	
	func testGeoJSONData() throws {
		// Arrange
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .millisecondsSince1970
		// API stores time in milliseconds
		let date = Date(timeIntervalSince1970: 1388620296020 / 1000)
		
		// Act
		let quakeResults = try decoder.decode(QuakeResults.self, from: geoJSONData)

		let quake = quakeResults.features[0]
		
		XCTAssertEqual(1.29, quake.mag, accuracy: 0.001)
		XCTAssertEqual("10km SSW of Idyllwild, CA", quake.place)
		XCTAssertEqual(date, quake.time)
		XCTAssertEqual(-116.7776667, quake.longitude, accuracy: 0.001)
		XCTAssertEqual(33.663333299999998, quake.latitude, accuracy: 0.001)
	}

	// Future testing
	// Invalid format, deal with, write a test, implement logic
	
	
}

// Style example
//class Quake2: NSObject, Decodable {
//	let properties: Properties
//	let geometry: Geometry
//
//	class Properties: Decodable {
//		let mag: Double
//	}
//	class Geometry: Decodable {
//		let longitude: Double
//
//	}
//}
//
//let x = Quake2()
//x.properties.mag
//x.geometry.longitude
