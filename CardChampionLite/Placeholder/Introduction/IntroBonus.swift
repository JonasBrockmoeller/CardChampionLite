//
//  IntroBonus.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 12.05.22.
//

import SwiftUI

struct IntroBonus: View {
    @Binding var nextView: Int
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width

        VStack {
            Spacer()

            Text("Bonus")
                .font(.title2.bold())
                .padding(.bottom)
            
            Text("The bonus value is calculated depending on how many cards are left in your deck and which rarity your played card displays.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: width * 0.9 , alignment: .center)
            
            Image("Bonus")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            Text("Fewer cards add up to an overall higher bonus modifier.")
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: width * 0.9 , alignment: .center)
            Divider()
            Text("A less rare card gives a higher bonus, to compensate for its lower initial value.")
                .font(.body)
                .multilineTextAlignment(.center)
                .frame(maxWidth: width * 0.9 , alignment: .center)
                        
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
            
            Spacer()
        }
    }
}

/*
struct IntroBonus_Previews: PreviewProvider {
    static var previews: some View {
        IntroBonus()
    }
}
*/
