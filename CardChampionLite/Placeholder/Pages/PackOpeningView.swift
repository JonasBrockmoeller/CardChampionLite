//
//  PackOpeningView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 25.04.22.
//

import SwiftUI

struct PackOpeningView: View {
    
    @Binding var isPresented: Bool
    var card: Card
    
    @State var rotation = false
    @State var packIsShown = true
    @State var recktangleIsClicked = false
    @State var backgroundIsClicked = false
    @State var imageIsClicked = false
    @State var nameIsClicked = false
    @State var atkIsClicked = false
    @State var intIsClicked = false
    @State var finished = false
    
    @State private var translation: CGSize = .zero
    let h = UIScreen.main.bounds.size.height
    let w = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack{
            ZStack{
                HStack(spacing: -5){
                    if packIsShown{
                        Image("\(card.rarity.lowercased())-pack-Left")
                            .rotationEffect(.degrees(Double(self.translation.width / w) * -10), anchor: .bottom)
                            .transition(.move(edge: .leading))
                            .frame(width: 227, height: 640)
                            .scaleEffect(h * 0.00038)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if value.startLocation.x > value.location.x {
                                            //swipe left
                                            self.translation = value.translation
                                        } else {
                                            //swipe right
                                        }
                                    }.onEnded({ value in
                                        withAnimation() {
                                            packIsShown = false
                                        }
                                        withAnimation(Animation.default.delay(0.5)){
                                            recktangleIsClicked = true
                                        }
                                    })
                            )
                        
                        Image("\(card.rarity.lowercased())-pack-Right")
                            .rotationEffect(.degrees(Double(self.translation.width / w) * 10), anchor: .bottom)
                            .transition(.move(edge: .trailing))
                            .frame(width: 227, height: 640)
                            .scaleEffect(h * 0.00038)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if value.startLocation.x > value.location.x {
                                            //swipe left
                                        } else {
                                            //swipe right
                                            self.translation = value.translation
                                        }
                                    }.onEnded({ value in
                                        withAnimation() {
                                            packIsShown = false
                                        }
                                        withAnimation(Animation.default.delay(0.5)){
                                            recktangleIsClicked = true
                                        }
                                    })
                            )
                    }
                }
                
                if recktangleIsClicked {
                    getBackground(card: card)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation{
                                backgroundIsClicked = true
                            }
                        }
                        .zIndex(0)
                    
                    Image(card.rarity+"Foreground")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation{
                                backgroundIsClicked = true
                            }
                        }
                        .zIndex(2)
                }
                
                if backgroundIsClicked {
                    Text(card.cardName)
                        .font(Font.custom("Futura", size: 30))
                        .foregroundColor(Color(hue: 1.0, saturation: 0.100, brightness: 1.2))
                        .shadow(radius: 1, x: 5, y: 5)
                        .shadow(radius: 1, x: 0, y: 0)
                        .position(x:  173,y: 595)
                        .contentShape(Rectangle())
                        .transition(.move(edge: .leading))
                        .onTapGesture {
                            withAnimation(.spring()){
                                imageIsClicked = true
                            }
                        }
                        .zIndex(3)
                    Image(card.imagePath)
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .contentShape(Rectangle())
                        .transition(.move(edge: .top))
                        .onTapGesture {
                            withAnimation(.spring()){
                                imageIsClicked = true
                            }
                        }
                        .zIndex(1)
                }
                
                if imageIsClicked {
                    createButton(buttonName: "AttackButton", scale: 0.26, bX: 375, bY: 113, value: card.atkValue, tX: 365, tY: 90){
                        
                    }
                    .allowsHitTesting(false)
                    .contentShape(Rectangle())
                    .transition(.move(edge: .trailing))
                    .onTapGesture {
                        withAnimation(.spring()){
                            atkIsClicked = true
                        }
                    }
                    .zIndex(3)
                }
                
                if atkIsClicked{
                    createButton(buttonName: "DefenseButton", scale: 0.32, bX: 376, bY: 267, value: card.defValue, tX: 365, tY: 260){
                        
                    }
                    .allowsHitTesting(false)
                    .contentShape(Rectangle())
                    .transition(.move(edge: .trailing))
                    .onTapGesture {
                        withAnimation(.spring()){
                            intIsClicked = true
                            finished = true
                        }
                    }
                    .zIndex(3)
                }
                
                if intIsClicked{
                    createButton(buttonName: "IntelligenceButton", scale: 0.33, bX: 368, bY: 435, value: card.intValue, tX: 367, tY: 420){
                        
                    }
                    .allowsHitTesting(false)
                    .transition(.move(edge: .trailing))
                    .zIndex(3)
                }
            }
            .frame(width: 441, height:640)
            .scaleEffect(h * 0.001)
            
            if finished{
                Button(action:{
                    isPresented = false
                }){
                    Text("Collect")
                        .frame(width: 250, height: 60)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
    }
    
    func getBackground(card: Card) -> some View{
        return Image(card.rarity+"Background")
            .resizable()
            .scaledToFit()
            .padding()
            .aspectRatio(contentMode: .fill)
    }
    
    func getRandomCard() -> Card {
        return Card(id: 3, cardName: "Professor X", imagePath: "ProfessorX", atkValue: 50, defValue: 60, intValue: 70, rarity: "Epic")
    }
}

/*struct PackOpeningView_Previews: PreviewProvider {
    static var previews: some View {
        PackOpeningView(isPresented: true, gamble: 1)
            .environmentObject(UnlockedCardsModel())
    }
}
*/
