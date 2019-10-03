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
		
		mapView.delegate = self
		mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "QuakeView")
		fetchQuakes()
	}
	
	func fetchQuakes() {
		quakeFetcher.fetchQuakes { (quakes, error) in
			
			if let error = error {
				print("Error: \(error)")
			}
			
			if let quakes = quakes {
				print("Quakes: \(quakes)")

				DispatchQueue.main.async {
					
					
					// Region of interest (ROI)
					// Rectangular region
					if let firstQuake = quakes.first {
						
						let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
						let region = MKCoordinateRegion(center: firstQuake.coordinate, span: span)
						
						self.mapView.setRegion(region, animated: true)
					}
					
					self.mapView.addAnnotations(quakes)
					
				}

			}
		}

	}
}

extension EarthquakesViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		// TODO: figure out how to handle multiple annoations if required ...
		guard let quake = annotation as? Quake else { fatalError("Invalid type"); return nil }
		
		guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "QuakeView") as? MKMarkerAnnotationView else { fatalError("Incorrect view is registered")
		}
		
		annotationView.glyphImage = UIImage(named: "QuakeIcon")
		
		if quake.mag >= 5 {
			annotationView.markerTintColor = .red
		} else if quake.mag >= 3 && quake.mag < 5 {
			annotationView.markerTintColor = .orange
		} else {
			annotationView.markerTintColor = .yellow
		}
		
		return annotationView
	}
	
}
