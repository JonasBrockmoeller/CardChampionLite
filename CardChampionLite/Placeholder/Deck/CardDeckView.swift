//
//  CardDeckView.swift
//  Placeholder
//
//  Created by Tim Weigand on 05.04.22.
//

import SwiftUI

struct CardDeckView: View {
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationView{
            Deck()
                .navigationTitle("Deck of cards")
                .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Image(systemName: "square.stack.fill")
                                        .foregroundColor(CustomColors.buttonColor)
                                        .padding(1)
                                    Text(" Deck of cards")
                                        .font(.title.bold())
                                        .foregroundColor(CustomColors.buttonColor)
                                    Spacer()
                                }
                            }
                        }
        }.frame(width: screenWidth, height: screenHeight * 0.8)
    }
}

struct CardDeckView_Previews: PreviewProvider {
    static var previews: some View {
        CardDeckView()
    }
}
