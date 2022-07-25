//
//  Created by Jonas Brockmöller, Jonas Klotzbach, Tim Weigand on 04.04.22.
//
import SwiftUI

var buttons = false
var connectionManager: ConnectionManager? = nil
var gameMechanic = GameMechanic()

struct Card: View, Codable, Equatable, Identifiable {
    var id: Int
    var cardName: String
    var imagePath: String
    var atkValue: Int
    var defValue: Int
    var intValue: Int
    var rarity: String
    
    func attack(){
        print("attack!")
        
        if let manager = connectionManager as? HostConnectionManager {
            // manager is a hostconnectionmanager. Do something with manager
            guard let myDeck = manager.deck else {return}
            manager.myCurrentValue = GameInformation(card: self, button: "atk", deckCount: myDeck.count)
            manager.matchup()
        }
        else if let manager = connectionManager as? PlayerConnectionManager{
            // manager is a playerconnectionmanager. Do something with manager
            manager.send(info: GameInformation(card: self, button: "atk", deckCount: manager.deck.count))
        }
        
    }
    
    func defend(){
        print("defend!")

        if let manager = connectionManager as? HostConnectionManager {
            // manager is a hostconnectionmanager. Do something with manager
            guard let myDeck = manager.deck else {return}
            manager.myCurrentValue = GameInformation(card: self, button: "def", deckCount: myDeck.count)
            manager.matchup()
        }
        else if let manager = connectionManager as? PlayerConnectionManager{
            // manager is a playerconnectionmanager. Do something with manager
            manager.send(info: GameInformation(card: self, button: "def", deckCount: manager.deck.count))
        }
    }
    
    func think(){
        print("think!")

        if let manager = connectionManager as? HostConnectionManager {
            // manager is a hostconnectionmanager. Do something with manager
            guard let myDeck = manager.deck else {return}
            manager.myCurrentValue = GameInformation(card: self, button: "int", deckCount: myDeck.count)
            manager.matchup()
        }
        else if let manager = connectionManager as? PlayerConnectionManager{
            // manager is a playerconnectionmanager. Do something with manager
            manager.send(info: GameInformation(card: self, button: "int", deckCount: manager.deck.count))
        }
    }
    
    var body: some View {
        ZStack {
            let uiImage = UIImage(named: imagePath)
            let missingPic = UIImage(named: "Missing")
            Image(rarity+"Background")
                .resizable()
                .scaledToFit()
                .padding()
                .aspectRatio(contentMode: .fill)
            Image(uiImage: uiImage ?? missingPic!)
                .resizable()
                .scaledToFit()
                .padding()
            Image(rarity+"Foreground")
                .resizable()
                .scaledToFit()
                .padding()
            Text(cardName)
                .font(Font.custom("Futura", size: 30))
                .foregroundColor(Color(hue: 1.0, saturation: 0.100, brightness: 1.2))
                .shadow(radius: 1, x: 5, y: 5)
                .shadow(radius: 1, x: 0, y: 0)
                .position(x:  173,y: 595)
            
            createButton(buttonName: "AttackButton", scale: 0.26, bX: 375, bY: 113, value: atkValue, tX: 365, tY: 90){
                attack()
            }.allowsHitTesting(buttons)
            
            createButton(buttonName: "DefenseButton", scale: 0.32, bX: 376, bY: 267, value: defValue, tX: 365, tY: 260){
                defend()
            }.allowsHitTesting(buttons)
            
            createButton(buttonName: "IntelligenceButton", scale: 0.33, bX: 368, bY: 435, value: intValue, tX: 367, tY: 420){
                think()
            }.allowsHitTesting(buttons)
            
        }.frame(width: 441, height:640)
        
    }
    
}

extension View {
    func setConnectionManager(_ myConnectionManager: ConnectionManager) -> some View{
        connectionManager = myConnectionManager
        return self
    }
    
    func enableButtons() -> some View {
        buttons = true
        return self
    }
    
    func disableButtons() -> some View {
        buttons = false
        return self
    }
}

func createButton(buttonName: String, scale: Double, bX: CGFloat, bY: CGFloat, value: Int, tX: CGFloat, tY: CGFloat, function: @escaping () -> Void) -> some View{
    ZStack{
        Button(action:{
            function()
        }){
            Image(uiImage: UIImage(named: buttonName)!)
                .resizable()
                .scaledToFit()
        }
        .scaleEffect(scale)
        .position(x: bX, y: bY)
        .allowsHitTesting(true)
        Text(String(value))
            .font(Font.custom("Futura", size: 50))
            .foregroundColor(Color(hue: 1.0, saturation: 0.100, brightness: 1))
            .shadow(radius: 1, x: 5, y: 5)
            .shadow(radius: 1, x: 0, y: 0)
            .position(x: tX, y: tY)
            .allowsHitTesting(false)
    }
    .frame(width: 441, height:640)
}

/*struct Card_Previews: PreviewProvider {
 static var previews: some View {
 let darthVader = Card(cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 50, defValue: 50, intValue: 50, rarity: "Legendary").scaleEffect(0.8)
 VStack(alignment: .trailing, spacing: -455){
 HStack (alignment: .center, spacing: -315){
 darthVader
 }
 }
 }
 }*/
