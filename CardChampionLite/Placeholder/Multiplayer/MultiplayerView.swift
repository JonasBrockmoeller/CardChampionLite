//
//  MultiplayerView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 09.04.22.
//
import SwiftUI

struct MultiplayerView: View {
    @StateObject var connectionManager: ConnectionManager
    @EnvironmentObject var deckModel: DeckModel
    
    var body: some View {
        VStack(alignment: .center) {
            Text("Connected Devices:")
                .bold()
            Text(String(describing: connectionManager.connectedPeers.map(\.displayName)))
            Text(String(describing: connectionManager.currentValue))
            
            Divider()
            
            deckModel.deck.first!
                .scaleEffect(0.7)
                .enableButtons()
                .setConnectionManager(connectionManager)
            
            Spacer()
        }
        .padding()
    }
    
}

struct MultiplayerView_Previews: PreviewProvider {
    static var previews: some View {
        MultiplayerView(connectionManager: HostConnectionManager())
            .environmentObject(DeckModel())
    }
}
