//
//  GameSelectionView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 19.04.22.
//

import SwiftUI

struct GameSelectionView: View {
    @StateObject var hostconnectionManager: HostConnectionManager = HostConnectionManager()
    @StateObject var playerconnectionManager: PlayerConnectionManager = PlayerConnectionManager()
    
    @State var hostViewActive = false
    @State var playerViewActive = false
    
    let example = [
        Card(id: 1, cardName: "Miles Morales", imagePath: "MilesMorales", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
        Card(id: 2, cardName: "Iron man", imagePath: "Ironman", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 3, cardName: "Rick & Morty", imagePath: "Rick&Morty", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 4, cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 5, cardName: "Baby Yoda", imagePath: "BabyYoda", atkValue: 10, defValue: 20, intValue: 20, rarity: "Common"),
        Card(id: 6, cardName: "Captain Marvel", imagePath: "CaptainMarvel", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 7, cardName: "James Bond", imagePath: "JamesBond", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 8, cardName: "Moon Knight", imagePath: "MoonKnight", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 9, cardName: "Thanos", imagePath: "Thanos", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
    ]
    
    var body: some View {
        Capsule()
            .fill(.gray)
            .frame(width: 40, height: 7)
            .padding(.top)
        
        NavigationView{
            VStack {
                                
                Button(action:{
                    hostconnectionManager.startAdvertising()
                    hostconnectionManager.setDeck(deck: example)
                    self.hostViewActive.toggle()
                }){
                    Text("Host a game")
                        .frame(width: 250, height: 60)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }.padding()
                
                NavigationLink(destination: ReceivedInvitationsView(connectionManager: hostconnectionManager), isActive: $hostViewActive) {}
                
                Button(action:{
                    playerconnectionManager.startBrowsing()
                    playerconnectionManager.setDeck(deck: example)
                    self.playerViewActive.toggle()
                }){
                    Text("Join a game")
                        .frame(width: 250, height: 60)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }.padding()
                
                NavigationLink(destination: OpponentSelectionView(connectionManager: playerconnectionManager), isActive: $playerViewActive) {}
            }
                Spacer()
        }
    }
}

struct GameSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        GameSelectionView()
    }
}
