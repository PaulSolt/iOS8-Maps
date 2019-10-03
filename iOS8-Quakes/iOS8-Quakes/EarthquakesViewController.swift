//
//  EarthquakesViewController.swift
//  iOS8-Quakes
//
//  Created by Paul Solt on 10/3/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import MapKit

class EarthquakesViewController: UIViewController {
	
	var quakeFetcher = QuakeFetcher()
	
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		fetchQuakes()
	}
	
	func fetchQuakes() {
		quakeFetcher.fetchQuakes { (quakes, error) in
			
			if let error = error {
				print("Error: \(error)")
			}
			
			if let quakes = quakes {
				print("Quakes: \(quakes)")
			}
		}

	}
}