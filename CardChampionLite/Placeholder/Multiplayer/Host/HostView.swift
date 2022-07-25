//
//  Host.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 19.04.22.
//

import SwiftUI

struct HostView: View {
    @StateObject var connectionManager: HostConnectionManager
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Text("Connected Devices:")
            
            Text(String(describing: connectionManager.connectedPeers.map(\.displayName)))
            
            Text("Opponents Value: \(String(describing: connectionManager.opponentsCurrentValue))")
            
            Text("My Value: \(String(describing: connectionManager.myCurrentValue))")
            
            Text("Result: \(connectionManager.result)")
            
            Divider()
            
            connectionManager.deck!.first
                .scaleEffect(0.7)
                .enableButtons()
                .setConnectionManager(connectionManager)
            
            Spacer()
        }
        .onDisappear(perform: connectionManager.disconnectFromSession)
        .padding()
        .navigationTitle("Host")
    }
}

/*
struct Host_Previews: PreviewProvider {
    static var previews: some View {
        HostView(connectionManager: HostConnectionManager())
    }
}
*/
