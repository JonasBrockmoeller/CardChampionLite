//
//  IntroCards.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 12.05.22.
//

import SwiftUI

struct IntroCards: View {
    @Binding var nextView: Int
    @State var type = "Card1W"
    @State var counter = 1
    @State var info: String = "There are 4 different rarities of cards, with common beeing the lowest and legendary beeing the highest."
    @State var buttonDisabled = true
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width
        
        VStack{
            Spacer()
            
            Text("Cards: \(counter) of 4")
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
            self.type = "Card2W"
            self.info = "Each of your cards resembles a unique champion you can use in your next matchup."
        case 3:
            self.type = "Card3W"
            self.info = "The values of a card increase or decrease depending on the rarity displayed."
        default:
            self.type = "Card4W"
            self.info = "In a match you send 9 champions into battle, to matchup against nearby players."
            buttonDisabled.toggle()
        }
    }
}

/*
 struct IntroCards_Previews: PreviewProvider {
 static var previews: some View {
 IntroCards()
 }
 }
 */
