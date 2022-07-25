//
//  IntroDeck.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 24.05.22.
//

import SwiftUI

struct IntroDeck: View {
    @Binding var nextView: Int
    @State var type = "Deck1W"
    @State var counter = 1
    @State var info: String = "Before you start a game, you need to choose 9 champions for your battle deck."
    @State var buttonDisabled = true
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width
        
        VStack{
            Spacer()
            
            Text("Deck: \(counter) of 2")
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
            if counter < 2{
                counter += 1
                updateType()
            }
        }
    }
    
    func updateType() {
        switch counter{
        default:
            self.type = "Deck2W"
            self.info = "When you have choosen your deck of champions, you are prepared to start a match."
            buttonDisabled.toggle()
        }
    }
}

/*struct IntroDeck_Previews: PreviewProvider {
    static var previews: some View {
        IntroDeck()
    }
}*/
