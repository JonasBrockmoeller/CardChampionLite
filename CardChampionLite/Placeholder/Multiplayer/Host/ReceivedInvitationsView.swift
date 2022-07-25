//
//  ReceivedInvitationsView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 20.04.22.
//

import SwiftUI
import SSSwiftUIGIFView

struct ReceivedInvitationsView: View {
    @StateObject var connectionManager: HostConnectionManager
    @State var isAccepted = false
    
    var body: some View {
        VStack{
            Text("Setting up the lobby")
                .font(.title)
            
            SwiftUIGIFPlayerView(gifName: "hostWaiting")
            
            /*
             Invisible and not clickable button but it is needed to show an alert when a invitation is received
             */
            Button("Show Invitations") {
            }
            .foregroundColor(.clear)
            .background(.clear)
            .allowsHitTesting(false)
            .alert("Do you want to play against \(connectionManager.receivedInvitation?.peerID.displayName ?? "")" ,
                   isPresented: $connectionManager.showAlert) {
                
                Button(action:{
                    print("Invitation accepted!")
                    connectionManager.acceptInvitation(invitation: connectionManager.receivedInvitation!)
                    self.isAccepted.toggle()
                }){
                    Text("Accept")
                        .bold()
                }
                
                Button("Decline") { connectionManager.declineInvitation(invitation: connectionManager.receivedInvitation!)}
            }.fullScreenCover(isPresented: $isAccepted){ HostGameView(connectionManager: connectionManager, isPresented: $isAccepted)
            }}
        .onAppear(perform: setDeck)
        .onDisappear(perform: connectionManager.stopAdvertising)
        
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

struct ReceivedInvitationsView_Previews: PreviewProvider {
    static var previews: some View {
        ReceivedInvitationsView(connectionManager: HostConnectionManager())
    }
}
