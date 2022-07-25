//
//  LocationExtension.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 25.04.22.
//
import Foundation
import MapKit

extension MapViewModel: CLLocationManagerDelegate {
    //This function verifies that the location service on the phone is enabled and that it can be used
    func checkIfLocationServiceIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            
            //Force unwrapping the locationManager here but it has been set literally the line above so it is ok to do so
            locationManager!.allowsBackgroundLocationUpdates = true
            locationManager!.delegate = self
        } else{
            //In this case the Location service on the phone is disabled -> Show a alert/ warning here
            print("error here")
            //TODO
        }
    }
    
    //This function checks if the user has approved
    //It is private so it cannot accidentally be called from the outside
    private func checkLocationAuthorization(){
        //unwrapping the optional location manager
        guard let locationManager = locationManager else {
            //Here we can just return, because the Location Manager must be present because the checkIfLocationServiceIsEnabled() function is called prior
            print("major error")
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
            region = MKCoordinateRegion(center: MapDetails.STARTING_LOCATION,
                                        span: MapDetails.DEFAULT_SPAN)
        @unknown default:
            break
        }
    }
    
    /*
     This overrides the locationManagerDidChangeAuthorization in the CLLocationManagerDelegate and it is automatically called by the Delegate when a CLLocationManager is created or when the apps authorization changes
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
