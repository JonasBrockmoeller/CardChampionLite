//
//  MapViewModel.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 06.04.22.
//
import CoreLocation
import MapKit
import UserNotifications
import SwiftUI

enum MapDetails{
    static let STARTING_LOCATION = CLLocationCoordinate2D(latitude: 51.3650, longitude: 6.4205)
    static let DEFAULT_SPAN = MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40)
}

/*
 notification tutorial used: https://www.raywenderlich.com/20690666-location-notifications-with-unlocationnotificationtrigger#toc-anchor-011
 */

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    //Coordinates of venlo and very zoomed out
    @Published var region = MKCoordinateRegion(center: MapDetails.STARTING_LOCATION,
                                               span: MapDetails.DEFAULT_SPAN)
    
    //LocationManager is an optional, because location service could be turned off on the users device
    var locationManager: CLLocationManager?
    
    //This function verifies that the location service on the phone is enabled and that it can be used
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            
            guard let locationManager = locationManager else {
                return
            }
            
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.delegate = self
            
            //Set location
            guard let location = locationManager.location else { return }
            region.center.latitude = location.coordinate.latitude
            region.center.longitude = location.coordinate.longitude
            region.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        } else{
            //In this case the Location service on the phone is disabled -> Show a alert/ warning here
            print("error here")
            //TODO: Show a alert/ warning here
        }
    }
    
    //This function checks if the user has approved
    //It is private so it cannot accidentally be called from the outside
    private func checkLocationAuthorization(){
        //unwrapping the optional location manager
        guard let locationManager = locationManager else {
            //Here we can just return, because the Location Manager must be present because the checkIfLocationServiceIsEnabled() function is called prior
            return
        }
        switch locationManager.authorizationStatus{
        case .notDetermined:
            //The authorization has not yet been requested: Request pop-up will be shown now
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location service is restricted")
            //Show alert that the location service is restricted and cannot be used by this app
        case .denied:
            print("Location service is denied")
            //Show alert that the user has denied the request and this needs to be changed in the settings
        case .authorizedAlways, .authorizedWhenInUse:
            guard locationManager.location != nil else {
                print("Cannot retrive location")
                return
            }
            print("Location service authorized")
        @unknown default:
            print("unknown state of location manager")
        }
    }
    
    /*
     This overrides the locationManagerDidChangeAuthorization in the CLLocationManagerDelegate and it is automatically called by the Delegate when a CLLocationManager is created or when the apps authorization changes
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           region.center.latitude = (manager.location?.coordinate.latitude)!
           region.center.longitude = (manager.location?.coordinate.longitude)!
       }
}
