//
//  HostGameView.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 05.05.22.
//

import SwiftUI
import ConfettiSwiftUI
import SSSwiftUIGIFView

struct HostGameView: View {
    @StateObject var connectionManager: HostConnectionManager
    @Binding var isPresented: Bool
    
    var body: some View {
        if !connectionManager.deck!.isEmpty && !connectionManager.connectedPeers.isEmpty{
            HostCardView(connectionManager: connectionManager, isPresented: $isPresented)
        } else{
            if connectionManager.roundsWon
                > connectionManager.roundsLost{
                WinnerView(isPresented: $isPresented, wins: connectionManager.roundsWon, lost: connectionManager.roundsLost)
            } else if connectionManager.roundsWon < connectionManager.roundsLost{
                LooserView(isPresented: $isPresented, wins: connectionManager.roundsWon, lost: connectionManager.roundsLost)
            } else if connectionManager.sessionstarted == false{
                VStack{
                    Button("close"){
                        isPresented.toggle()
                    }
                    SwiftUIGIFPlayerView(gifName: "waiting2")
                }
            }
        }
    }
}

struct HostCardView: View{
    @StateObject var connectionManager: HostConnectionManager
    @Binding var isPresented: Bool
    
    let height = UIScreen.main.bounds.size.height
    let width = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(){
            ZStack{
                HStack(){
                    Image(systemName: "dice.fill")
                        .foregroundColor(CustomColors.buttonColor)
                        .scaleEffect(1.5)
                        .padding()
                    
                    Spacer()
                    
                    Button("close"){
                        isPresented.toggle()
                    }
                    .padding(.trailing)
                }
                VStack(){
                    Text("Game against: ")
                        .font(.title2)
                        .foregroundColor(CustomColors.buttonColor)
                    Text(connectionManager.connectedPeers.first?.displayName ?? "")
                        .font(.title2)
                        .foregroundColor(CustomColors.buttonColor)
                }
            }
            
            Divider()
            
            Text("\(connectionManager.result)")
                .font(.title.bold())
                .foregroundColor(CustomColors.buttonColor)
                .lineLimit(1)
                .padding()
                .confettiCannon(counter: $connectionManager.showConfetti, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)


            getCard()
                .scaleEffect(height * 0.001)
                .frame(width: width, height: height * 0.7)
                .enableButtons()
                .setConnectionManager(connectionManager)
            
            HStack(){
                Spacer()
                Text("Cards left: ")
                    .font(.title2.bold())
                    .foregroundColor(CustomColors.buttonColor)
                Text("\(connectionManager.deck!.count)")
                    .font(.title2.bold())
                    .foregroundColor(.blue)
                Image(systemName: "square.stack.fill")
                    .foregroundColor(CustomColors.buttonColor)
                Spacer()
                    .frame(width: width * 0.08)
            }
        }
        .frame(width: width, height: height)
        .edgesIgnoringSafeArea(.all)
        .onDisappear(){
            self.connectionManager.disconnectFromSession()
        }
    }
    
    func getCard() -> Card? {
        if let deck = connectionManager.deck{
            if let card = deck.first{
                return card
            } else {
                //TODO: return that player has won to player and present that host lost
                //TODO: save stats to Database
                //isPresented = false
            }
        } else{
            isPresented = false
        }
        return Card(id: 0, cardName: "", imagePath: "Missing", atkValue: 0, defValue: 0, intValue: 0, rarity: "Common")
    }
}

/*
struct HostGameView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameView(connectionManager: HostConnectionManager())
    }
}
*/
