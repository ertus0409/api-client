//
//  MapSelectVC.swift
//  api-client
//
//  Created by Guner Babursah on 09/06/2018.
//  Copyright © 2018 PDevelop. All rights reserved.
//

import UIKit
import MapKit

class MapSelectVC: UIViewController, MKMapViewDelegate {
    
    //IBOUTLETS:
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    
    //VARIABLES:
    var selectedFoodTruck: FoodTruck?
    
    
    var truckLocation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Truck : ", selectedFoodTruck?.name)
        
        if let truck = selectedFoodTruck {
            let initialLocation = CLLocation(latitude: truck.lat, longitude: truck.long)
            centerMapOnLocation(location: initialLocation)
        }
        
        saveBtn.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseLocationTapped(_ sender: Any) {
        let lat = mapView.centerCoordinate.latitude
        let long = mapView.centerCoordinate.longitude
        
        truckLocation.title = selectedFoodTruck?.title
        truckLocation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        mapView.addAnnotation(truckLocation)
        
        latitudeLbl.text = "\(lat)"
        longitudeLbl.text = "\(long)"
        
        saveBtn.isHidden = false
    }
    
    @IBAction func saveLocationtapped(_ sender: Any) {
        AddTruckVC.mapLatitude = "\(truckLocation.coordinate.latitude)"
        AddTruckVC.mapLongitude = "\(truckLocation.coordinate.longitude)"
        
        dismissViewController()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationVeiw = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationVeiw == nil {
            annotationVeiw = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationVeiw?.canShowCallout = true
        } else {
            annotationVeiw?.annotation = annotation
        }
        
        return annotationVeiw
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func backButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    @IBAction func cancelButtonTapped(sender: UIButton) {
        dismissViewController()
    }
    
    
    func dismissViewController() {
        OperationQueue.main.addOperation {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    

}
