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
	// mag
	// place
	// time
	// long
	// lat
	
	let mag: Double
//	let place: String
//	let time: Date
//	let longitude: Double
//	let latitude: Double
	
	enum QuakeCodingKeys: String, CodingKey {
		case mag
		case place
		case time
		
		case properties
		case geometry
		
//		case long
		
	}
	
	
	required init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
		
		let properties = try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
		
		// TODO: may want to return nil if we cannot decode
		// if at the end
		
		mag = try properties.decode(Double.self, forKey: .properties)
		
		
		
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
		}
	}
	
	func testQuakeJSON() throws {
		
		let decoder = JSONDecoder()
		
		let quake = try decoder.decode(Quake.self, from: quakeData)
		XCTAssertEqual(1.29, quake.mag, accuracy: 0.01)
		
	}
	

}
