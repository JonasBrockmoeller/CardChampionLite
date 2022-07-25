//
//  CardDrop.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 06.04.22.
//

import Foundation
import CoreLocation

/*
 A CardDrop is a place displayed on the map where new cards can be unlocked when the user comes close to the location
 */
struct CardDrop: Identifiable, Codable, Equatable{
    let id: Int
    let lat: Double
    let lng: Double
    /*let country: String
    let city: String*/
    
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
    }
    
    static let example = CardDrop(id: 1, lat: 37.33182000, lng: -122.03118000)
}
