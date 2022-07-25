//
//  IntroGame.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 24.05.22.
//

import SwiftUI

struct IntroGame: View {
    @Binding var nextView: Int
    @State var type = "Game1W"
    @State var counter = 1
    @State var info: String = "You start a game with all 9 elected champions in your deck. Every round you select one attribute of your card."
    @State var buttonDisabled = true
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width
        
        VStack{
            Spacer()
            
            Text("Game: \(counter) of 4")
                .font(.title2.bold())
            
            if buttonDisabled{
                Text("Tap the image to continue")
                    .font(.caption.italic())
            }
            
            Image(type)
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fit)
                        
            Text(info)
                .font(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: width * 0.9 , alignment: .center)
            
            if !buttonDisabled{
                Button{
                    nextView += 1
                } label: {
                    Text("Next step")
                        .font(.title)
                        .frame(width: 250, height: 60)
                        .foregroundColor(CustomColors.textColor)
                        .background(.blue)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
            
        }
        .onTapGesture {
            if counter < 4{
                counter += 1
                updateType()
            }
        }
    }
    
    func updateType() {
        switch counter{
        case 2:
            self.type = "Game2W"
            self.info = "After you selected one attribute, it is compared with the oponents value and if you win, your champion is moved to the end of your deck."
        case 3:
            self.type = "Game3W"
            self.info = "However if you lose the round, your champion is defeated and removed from your deck for the time of this game."
        default:
            self.type = "Game4W"
            self.info = "The player who succeds in removing all the oponents champions from their deck first, wins the game."
            buttonDisabled.toggle()
        }
    }
}

/*struct IntroGame_Previews: PreviewProvider {
    static var previews: some View {
        IntroGame()
    }
}*/
