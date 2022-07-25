//
//  MapView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 06.04.22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var mapViewModel = MapViewModel()
    @State private var userTrackingMode = MapUserTrackingMode.follow
    
    @State var distanceAlert = false
    @State var timeAlert = false
    @State var packCollected = false
    @State var spots = [
        CardDrop(id: 1, lat: 37.33182000, lng: -136.03118000),
        CardDrop(id: 2, lat: 35.33182000, lng: -112.03118000),
        CardDrop(id: 3, lat: 36.33182000, lng: -13.03118000),
        CardDrop(id: 4, lat: 38.33182000, lng: 74.03118000),
        CardDrop(id: 5, lat: 39.33182000, lng: 34.03118000),
    ]
    
    var notificationManager = NotificationManager()
    
    var body: some View {
        //Displays a map and has a Binding to the region variable to automatically update the location
        ZStack {
            
            getMap()
            
            VStack {
                //Pushes the Button to the bottom
                Spacer()
                
                HStack {
                    //Pushes the button to the right
                    Spacer()
                    
                    //Gets the Focus Location Button
                    getButton()
                }
            }
        }
    }
    
    
    func getMap() -> some View{
        Map(
            coordinateRegion: $mapViewModel.region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: spots
        ){cardDrop in
            MapAnnotation(coordinate: cardDrop.coordinate){
                Image("LoadingIcon")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .onTapGesture {
                        guard getDistance(from: cardDrop.coordinate, to: mapViewModel.region.center).isLess(than: 100) == true else{
                            self.distanceAlert = true
                            return
                        }
                        
                        print("Collected")
                        self.packCollected = true
                    }
                    .alert("You need to get closer to the CardDrop to open it", isPresented: self.$distanceAlert) {
                        Button("OK") { self.distanceAlert = false}
                    }
                    .alert("You need to wait an hour to the CardDrop to open it", isPresented: self.$timeAlert) {
                        Button("OK") { self.timeAlert = false}
                    }
                    .alert("You collected a new Pack. Open it in the home menu", isPresented: self.$packCollected) {
                        Button("OK") { self.packCollected = false}
                    }
            }
            
        }
        .edgesIgnoringSafeArea(.top)
        .accentColor(Color(.systemPink))
        .onAppear(){
            mapViewModel.checkIfLocationServiceIsEnabled()
            notificationManager.requestNotificationServiceAuthorization()
        }
    }
    
    
    /*
     This returns the butoon that focusses the map on the current user location
     */
    func getButton() -> some View{
        Button(action:{
            userTrackingMode = MapUserTrackingMode.follow
        }){
            Image(systemName: "location.viewfinder")
                .resizable()
                .scaledToFit()
                .foregroundColor(CustomColors.textColor)
                .frame(width: 30, height: 30, alignment: .center)
        }
        .frame(width: 50, height: 50)
        .background(.blue)
        .clipShape(Circle())
        .padding()
    }
    
    func makeTriggers(cardCollectionSpots: [CardDrop]){
        for spot in cardCollectionSpots {
            let triggerRegion = makeTriggerRegion(location: spot.coordinate)
            notificationManager.postTriggeredNotification(region: triggerRegion)
        }
    }
    
    private func makeTriggerRegion(location: CLLocationCoordinate2D) -> CLCircularRegion {
        let region = CLCircularRegion(
            center: location,
            radius: 100,
            identifier: UUID().uuidString)
        region.notifyOnEntry = true
        return region
    }
    
    func getRandomPack() -> String{
        let randomNumber = Int.random(in: 0...100)
        switch(randomNumber) {
        case 0..<50:
            return "Common"
        case 50..<80:
            return "Rare"
        case 80..<95:
            return "Epic"
        case 95...100:
            return "Legendary"
        default:
            return "Common"
        }
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
