//
//  iOS8_QuakesTests.swift
//  iOS8-QuakesTests
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import XCTest

// MKAnnotation requires a subclass of NSObject (can't use a Swift struct)

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





class Quake: NSObject, Decodable {
	
	let mag: Double
	let place: String
	let time: Date
	let longitude: Double
	let latitude: Double
	
	enum QuakeCodingKeys: String, CodingKey {
		case mag
		case place
		case time
		
		case properties
		case geometry
		case coordinates
//		case long
		
	}
	
	
	required init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
		let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
		let geometry = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .geometry)
		var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
		
		mag = try properties.decode(Double.self, forKey: .mag)
		place = try properties.decode(String.self, forKey: .place)
		time = try properties.decode(Date.self, forKey: .time)

		longitude = try coordinates.decode(Double.self)
		latitude = try coordinates.decode(Double.self)
		//		_ = try coordinates.decode(Double.self) // Ignore depth
		
		// TODO: may want to return nil if we cannot decode
		// if at the end

		super.init()
	}
}

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
	

}
