//
//  ShopmapViewController.swift
//  collection
//
//  Created by Admin on 11/25/17.
//  Copyright © 2017 hadhoud. All rights reserved.
//

import UIKit
import GoogleMaps
class ShopmapViewController: UIViewController , CLLocationManagerDelegate , GMSMapViewDelegate{
    
    @IBOutlet weak var durationlabel: UILabel!
    @IBOutlet weak var distancelabel: UILabel!
    
    @IBOutlet weak var shopmapview: GMSMapView!
    var canaccessmylocation: Bool = false
    var locationManager = CLLocationManager()
    var mapView : GMSMapView!
    var mylocation: CLLocation!
    var shoplocation: CLLocation!
    var haveaccesstolocation: Bool = false
    //   var path : GMSPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.shoplocation = CLLocation(latitude: 33.531735, longitude: 35.654165)
        // Do any additional setup after loading the view.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: self.shoplocation.coordinate.latitude , longitude: self.shoplocation.coordinate.longitude , zoom: 12.0)
        shopmapview.camera = camera
        let colorred = UIColor.red
        createMarker( titleMarker: "Shop", latitude: shoplocation.coordinate.latitude, longitude: shoplocation.coordinate.longitude , color: colorred )
        self.shopmapview.delegate = self
        self.shopmapview.isMyLocationEnabled = true
    }
    
    
    @IBAction func shopmapgoitemcloick(_ sender: UIBarButtonItem) {
        
        locationManager.startUpdatingLocation()
        // check location access
        if canaccessmylocation {
            let colorgreen = UIColor.green
            
            createMarker(titleMarker: "MyLocation", latitude: self.mylocation.coordinate.latitude, longitude: self.mylocation.coordinate.longitude , color: colorgreen )
            drawPath(startLocation: self.mylocation , endLocation: shoplocation)
        }
            
        else
        {
            // alert if no access to location
            let alert = UIAlertController(title: "No Location Access", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let cancel = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
            
            let gotosetting = UIAlertAction.init(title: "Go To Settings", style: .default, handler: { (alert: UIAlertAction!) in
                
                // check if ios 10 and newer
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
                }
            })
            alert.addAction(gotosetting)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
        
        
        
    }
    
    
    func createMarker(titleMarker: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees , color:UIColor) {
        
        let marker = GMSMarker()
        marker.map = nil
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.appearAnimation = .pop
        marker.icon = GMSMarker.markerImage(with: color)
        marker.map = self.shopmapview
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let myl = locations.last else {return}
        self.mylocation = myl
        // self.locationManager.stopUpdatingLocation()
    }
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
        let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
        let googleapi = "AIzaSyCe34okDPq8eoGgXJ-1ukVYLJjt9OYRUv8"
        let jurl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(googleapi)"
        
        print(jurl)
        
        guard let url = URL(string: jurl) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data , response ,err) in
            guard let data = data else { return }
            do {
                
                guard let jsonDictionary = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? NSDictionary
                    else {return}
                
                print(jsonDictionary)
                //  let status = jsonDictionary["status"] as! NSString
                
                let arrayroute = jsonDictionary["routes"] as! NSArray
                let dic = arrayroute[0] as! NSDictionary
                let overview = dic["overview_polyline"] as! NSDictionary
                let points = overview["points"] as! String
                // get legs
                let arraylegs = dic["legs"] as! NSArray
                let diclegs = arraylegs[0] as! NSDictionary
                //get distance
                let distance = diclegs["distance"] as! NSDictionary
                let distancevalue = distance["text"] as! String
                // get duration
                let duration = diclegs["duration"] as! NSDictionary
                let durationvalue = duration["text"] as! String
                
                print("\n \(distancevalue)")
                print("\n \(durationvalue)")
                DispatchQueue.main.async {
                    let path = GMSPath.init(fromEncodedPath: points)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 4
                    polyline.strokeColor = UIColor.red
                    polyline.map = self.shopmapview
                    self.distancelabel.text = distancevalue
                    self.durationlabel.text = durationvalue
                    let bounds = GMSCoordinateBounds(path: path!)
                    let camera: GMSCameraUpdate = GMSCameraUpdate.fit(bounds)
                    self.shopmapview.animate(with: camera)
                }
                
            } catch let err {
                print(err)
            }
            
        }
        task.resume()
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
            canaccessmylocation = false
        case .denied:
            canaccessmylocation = false
            print("User denied access to location.")
        case .notDetermined:
            canaccessmylocation = false
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK")
            canaccessmylocation = true
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //   print("\n You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
    
}

