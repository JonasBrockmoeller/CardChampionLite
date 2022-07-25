//
//  IntroMatch.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 12.05.22.
//

import SwiftUI

struct IntroAttributes: View {
    @Binding var nextView: Int
    @State var imagePath: String = "Attribute1W"
    @State var counter = 1
    @State var info: String = "Each card has 3 attributes: Attack, Defense and Intelligence."
    @State var buttonDisabled = true
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width
        
        VStack {
            Spacer()
            
            Text("Attributes: \(counter) of 3")
                .font(.title2.bold())
            
            if buttonDisabled{
                Text("Tap the image to continue")
                    .font(.caption.italic())
            }
            
            Image(imagePath)
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
            if counter < 3{
                counter += 1
                updateType()
            }
        }
    }
    
    func updateType() {
        switch counter{
        case 2:
            self.imagePath = "Attribute2W"
            self.info = "Like in Rock-Paper-Scissors, each attibute is effective against one other."
        default:
            self.imagePath = "Attribute3W"
            self.info = "In case an attribute is effective, a bonus is added to its initial value."
            buttonDisabled.toggle()
        }
    }
}

/*
 struct IntroMatch_Previews: PreviewProvider {
 static var previews: some View {
 IntroMatch()
 }
 }
 */
