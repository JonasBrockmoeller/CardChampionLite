//
//  IntroMap.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 24.05.22.
//

import SwiftUI

struct IntroMap: View {
    @Binding var nextView: Int
    
    var body: some View {
        let width = UIScreen.main.bounds.size.width

        VStack {
            Spacer()

            Text("Card collection")
                .font(.title2.bold())
                .padding(.bottom)
            
            Text("To collect new cards, you need to look out for spots around you, like the one shown below.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .frame(maxWidth: width * 0.9 , alignment: .center)
            
            Image("MapW")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Spacer()
            
            Text("If you get close enough to one of these spots, you can collect a pack which provides you with a new champion card.")
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
 struct IntroMap_Previews: PreviewProvider {
    static var previews: some View {
        IntroMap()
    }
}*/
