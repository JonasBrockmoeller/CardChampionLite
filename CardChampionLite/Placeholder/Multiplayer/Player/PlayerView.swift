//
//  Player.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 19.04.22.
//

import SwiftUI

struct PlayerView: View {
    @EnvironmentObject var deckModel: DeckModel
    @StateObject var connectionManager: PlayerConnectionManager
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Connected Devices:")
                .bold()
            Text(String(describing: connectionManager.connectedPeers.map(\.displayName)))
            
            Divider()
            
            deckModel.deck.first!
                .scaleEffect(0.7)
                .enableButtons()
                .setConnectionManager(connectionManager)
            
            Spacer()
        }
        .onDisappear(perform: connectionManager.disconnectFromSession)
        .padding()
        .navigationTitle("Player")
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(connectionManager: PlayerConnectionManager())
            .environmentObject(DeckModel())
    }
}
