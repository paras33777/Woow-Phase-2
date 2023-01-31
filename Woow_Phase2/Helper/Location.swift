//
//  Location.swift
//  
//
//  Created by Rahul Chopra on 05/06/21.
//

import Foundation
import UIKit
import CoreLocation
import JioAdsFramework

protocol LocationDelegate {
    func didChangeAuthorization(status: CLAuthorizationStatus)
    func didGetCoordinates(location: CLLocation)
}

struct LocationModel {
    let coordinates: CLLocationCoordinate2D
    let fullAdress: String
    let thoroughfare: String
    let sublocality: String
    let locality: String
    let state: String
    let country: String
    let postalCode: String
}


class SearchAddressModel {
   var address: String?
   var placeId: String?
   var primaryAddress: String?
   var secondaryAddress: String?
   
   init(dict: [String:Any]) {
      if let desc = dict["description"] as? String {
         self.address = desc
      }
      if let place_id = dict["place_id"] as? String {
         self.placeId = place_id
      }
      if let structured_formatting = dict["structured_formatting"] as? [String:Any] {
         if let mainText = structured_formatting["main_text"] as? String {
            self.primaryAddress = mainText
         }
         if let secondaryText = structured_formatting["secondary_text"] as? String {
            self.secondaryAddress = secondaryText
         }
      }
   }
}

class Location: NSObject {
   
    static let shared = Location()
    var locationManager = CLLocationManager()
    var currentCoordinates: CLLocationCoordinate2D?
    var addressModel = [SearchAddressModel]()
    var delegate: LocationDelegate?
    var isGetCurrentCoordinates: Bool = false
    var isLocationSaved: Bool = false
    var lastHeading: CLHeading?
    var location: CLLocation?
   
    func configure() {
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            if self.authorizationStatus() == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.startUpdatingLocation()
                locationManager.startUpdatingHeading()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func isLocationEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    func userBearing() -> CLLocationDegrees {
        let heading = lastHeading?.magneticHeading ?? 0
        return heading
    }
   
}


// MARK:- CORE LOCATION DELEGATE METHODS
extension Location: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if delegate != nil {
            delegate?.didChangeAuthorization(status: status)
        }
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if !isGetCurrentCoordinates {
            guard let location = locations.first else { return }
            self.currentCoordinates = location.coordinate
            self.location = location
//        JioAdSdk.userLocation = location
            print("Current Coordinates: \(self.currentCoordinates!)")
            
            if delegate != nil {
                delegate?.didGetCoordinates(location: location)
            }
            locationManager.stopUpdatingLocation()
            isGetCurrentCoordinates = true
//        }
    }
}
