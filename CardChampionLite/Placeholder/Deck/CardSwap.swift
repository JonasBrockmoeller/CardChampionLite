//
//  CardSwap.swift
//  Placeholder
//
//  Created by Tim Weigand on 06.04.22.
//

import SwiftUI

struct CardSwap: View {
    var example = [
        Card(id: 1, cardName: "Miles Morales", imagePath: "MilesMorales", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
        Card(id: 2, cardName: "Iron man", imagePath: "Ironman", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 3, cardName: "Rick & Morty", imagePath: "Rick&Morty", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 4, cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 5, cardName: "Baby Yoda", imagePath: "BabyYoda", atkValue: 10, defValue: 20, intValue: 20, rarity: "Common"),
        Card(id: 6, cardName: "Captain Marvel", imagePath: "CaptainMarvel", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 7, cardName: "James Bond", imagePath: "JamesBond", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 8, cardName: "Moon Knight", imagePath: "MoonKnight", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 9, cardName: "Thanos", imagePath: "Thanos", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
    ]
    
    var benchwarmers = [
        Card(id: 1, cardName: "Steve", imagePath: "Steve", atkValue: 10, defValue: 20, intValue: 30, rarity: "Common"),
        Card(id: 2, cardName: "Rocket", imagePath: "Rocket", atkValue: 30, defValue: 40, intValue: 50, rarity: "Rare"),
        Card(id: 3, cardName: "Professor X", imagePath: "ProfessorX", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic"),
        Card(id: 4, cardName: "Link", imagePath: "Link", atkValue: 70, defValue: 80, intValue: 90, rarity: "Legendary"),
        Card(id: 5, cardName: "Joker", imagePath: "Joker", atkValue: 10, defValue: 20, intValue: 20, rarity: "Common"),
    ]

    var cardToSwapOut: Card
    var indexOfCardToSwapOut: Int
    @State var indexOfCardToSwapIn: Int = 0
    @Binding var isSwapCardsViewPresented: Bool
    @State private var translation: CGSize = .zero
    @State private var filter: Filter = .ALL
    
    private var filteredCardsArray: [Card]{
        switch filter{
        case .ALL: return benchwarmers
        case .BRONZE: return benchwarmers.filter{$0.rarity == "Common"}
        case .SILVER: return benchwarmers.filter{$0.rarity == "Rare"}
        case .GOLD: return benchwarmers.filter{$0.rarity == "Epic"}
        case .PINK: return benchwarmers.filter{$0.rarity == "Legendary"}
        }
    }
    
    var body: some View {
        let h = UIScreen.main.bounds.size.height
        let w = UIScreen.main.bounds.size.width
        VStack{
            Capsule()
                .fill(.gray)
                .frame(width: 40, height: 7)
                .padding(.top)
            
            Spacer()

            HStack{
                Spacer()
                
                getFilterButton(color: Color(CustomColors.common), action: {
                    self.indexOfCardToSwapIn = 0
                    self.filter = .BRONZE
                })
                
                getFilterButton(color: Color(CustomColors.rare), action: {
                    self.indexOfCardToSwapIn = 0
                    self.filter = .SILVER
                })
                
                getFilterButton(color: Color(CustomColors.epic), action: {
                    self.indexOfCardToSwapIn = 0
                    self.filter = .GOLD
                })
                
                getFilterButton(color: Color(CustomColors.legendary), action: {
                    self.indexOfCardToSwapIn = 0
                    self.filter = .PINK
                })
                
                Spacer()
                
                getFilterButton(color: .blue, action: {
                    self.indexOfCardToSwapIn = 0
                    self.filter = .ALL
                })
                
                Spacer()
            }
            
            Spacer()
            
            if filteredCardsArray.count > 0{
                filteredCardsArray[$indexOfCardToSwapIn.wrappedValue]
                    .scaleEffect(h * 0.001)
                    .offset(x: self.translation.width, y: 0)
                    .rotationEffect(.degrees(Double(self.translation.width / w) * 10), anchor: .center)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.translation = value.translation
                            }.onEnded({ value in
                                self.translation = .zero
                                if value.translation.width < 0 {
                                    //swipe left
                                    increaseIndex(arraySize: filteredCardsArray.count)
                                }
                                
                                if value.translation.width > 0 {
                                    //swipe right
                                    decreaseIndex(arraySize: filteredCardsArray.count)
                                }
                            })
                    )
                    .frame(width: w * 0.8, height: h * 0.65)
            }
            
            //2 Spacers to keep the swap button in the middle between the bottom  of the card and the bottom of the display
            Spacer()
            
            Button(action: {
                //Closes the sheet
                isSwapCardsViewPresented = false
            })
            {
                Image(systemName: "rectangle.2.swap")
                    .rotationEffect(.degrees(90))
                    .scaleEffect(h * 0.003)
                    .background()
                    .foregroundColor(.blue)
            }
            .disabled(filteredCardsArray.count == 0 ? true : false)
            
            Spacer()
        }
    }
    
    func increaseIndex(arraySize: Int){
        if indexOfCardToSwapIn < arraySize-1{
            indexOfCardToSwapIn += 1
        } else {
            indexOfCardToSwapIn = 0
        }
    }
    
    func decreaseIndex(arraySize: Int){
        if indexOfCardToSwapIn > 0{
            indexOfCardToSwapIn -= 1
        } else {
            indexOfCardToSwapIn = arraySize-1
        }
    }
    
    func getFilterButton(color: Color, action: @escaping () -> Void) -> some View{
        Button(action: action){
            RoundedRectangle(cornerRadius: 2, style: .continuous)
                .foregroundColor(color)
                .frame(width: 20, height: 30)
        }
        .padding([.leading, .trailing], 5)
    }
}
