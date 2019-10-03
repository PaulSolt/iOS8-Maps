//
//  Quake.swift
//  iOS8-Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import Foundation
import MapKit

class QuakeResults: Decodable {
	let features: [Quake]
}

// MKAnnotation requires a subclass of NSObject (can't use a Swift struct)
class Quake: NSObject, Decodable {
	
	let mag: Double
	let place: String
	let time: Date
	
	private let longitude: Double
	private let latitude: Double
	
	enum QuakeCodingKeys: String, CodingKey {
		case mag
		case place
		case time

		// Containers
		case properties
		case geometry
		case coordinates
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

extension Quake: MKAnnotation {
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: latitude,
									  longitude: longitude)
	}
	
	var title: String? {
		place
	}
	
	var subtitle: String? {
		"Magnitude: \(mag)"
	}
}
