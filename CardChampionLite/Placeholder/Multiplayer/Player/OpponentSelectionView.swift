//
//  OpponentSelectionView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 19.04.22.
//

import SwiftUI
import SSSwiftUIGIFView

struct OpponentSelectionView: View {
    @StateObject var connectionManager: PlayerConnectionManager
    @State var isSent = false
    
    var body: some View {
        ZStack{
            VStack{
                Text("Looking for nearby players")
                    .font(.title)
                
                List(connectionManager.nearbyOpponents) { row in
                    Button(action:{
                        print("Invitation sent!")
                        connectionManager.inviteOpponent(browser: row.browser, peerID: row.foundPeer)
                        self.isSent.toggle()
                    }){
                        Text(row.foundPeer.displayName)
                            .bold()
                    }.fullScreenCover(isPresented: $isSent){
                        PlayerGameView(connectionManager: connectionManager, isPresented: $isSent)
                    }
                }
            }
            
            VStack{
                Spacer()
                SwiftUIGIFPlayerView(gifName: "playerWaiting")
            }.allowsHitTesting(false)
        }
        .onAppear(perform: setDeck)
        .onDisappear(perform: connectionManager.stopBrowsing)
    }
    
    func setDeck(){
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
        
        connectionManager.setDeck(deck: example)
        connectionManager.reset()
    }
}

struct OpponentSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        OpponentSelectionView(connectionManager: PlayerConnectionManager())
    }
}
