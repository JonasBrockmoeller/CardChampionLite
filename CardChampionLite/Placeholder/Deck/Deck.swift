//
//  Deck.swift
//  Placeholder
//
//  Created by Tim Weigand on 05.04.22.
//

import SwiftUI

struct Deck: View {
    
    var body: some View {
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        
        //Grid Layout of 9 cards in the deck in a 3x3 formation
        VStack(){
            RowOf3Cards(cardLeft: 0, cardMiddle: 1, cardRight: 2)
            
            RowOf3Cards(cardLeft: 3, cardMiddle: 4, cardRight: 5)
            
            RowOf3Cards(cardLeft: 6, cardMiddle: 7, cardRight: 8)
        }
        .frame(width: width, height: height * 0.75)
    }
}

struct RowOf3Cards: View{
    @State private var testLeft = false
    @State private var testMiddle = false
    @State private var testRight = false
    
    var cardLeft: Int
    var cardMiddle: Int
    var cardRight: Int

    var body: some View{
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        //Puts 3 cards next to each other horizontally
        HStack{
            getCard(cardIndex: cardLeft, isPresented: $testLeft)
            
            getCard(cardIndex: cardMiddle, isPresented: $testMiddle)
            
            getCard(cardIndex: cardRight, isPresented: $testRight)
        }
        .frame(width: screenWidth, height: screenHeight * 0.22)
    }
    
    func getCard(cardIndex: Int, isPresented: Binding<Bool>) -> some View {
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        let example = [
            Card(id: 1, cardName: "Miles Morales", imagePath: "MilesMorales", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
            Card(id: 2, cardName: "Iron man", imagePath: "IronMan", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
            Card(id: 3, cardName: "Rick & Morty", imagePath: "Rick&Morty", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
            Card(id: 4, cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
            Card(id: 5, cardName: "Baby Yoda", imagePath: "BabyYoda", atkValue: 10, defValue: 20, intValue: 20, rarity: "Common"),
            Card(id: 6, cardName: "Captain Marvel", imagePath: "CaptainMarvel", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
            Card(id: 7, cardName: "James Bond", imagePath: "JamesBond", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
            Card(id: 8, cardName: "Moon Knight", imagePath: "MoonKnight", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
            Card(id: 9, cardName: "Thanos", imagePath: "Thanos", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
        ]
        
        return example[cardIndex]
            .scaleEffect(screenHeight * 0.00035)
            .frame(width: screenWidth * 0.31, height: screenHeight * 0.23)
            .onTapGesture {
                isPresented.wrappedValue.toggle()
            }
            .sheet(isPresented: isPresented) {
                CardSwap(cardToSwapOut: example[cardIndex], indexOfCardToSwapOut: cardIndex, isSwapCardsViewPresented: isPresented)
            }
    }
}


struct Deck_Previews: PreviewProvider {
    static var previews: some View {
        Deck()
    }
}
