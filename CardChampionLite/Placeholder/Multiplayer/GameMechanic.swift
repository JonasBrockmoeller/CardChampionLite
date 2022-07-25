//
//  GameMechanic.swift
//  Placeholder
//
//  Created by Jonas Klotzbach on 24.04.22.
//

import Foundation

class GameMechanic {
    
    /*
     0: Draw
     1: Host wins
     2: Player wins
     */
    func compareValues(card1: Card, button1: String, deckCount1: Int, card2: Card, button2: String, deckCount2: Int) -> Int{
        var value1: Int
        var value2: Int
        
        //Get values from both players cards and calculate eventual bonus for effectiveness
        switch button1{
        case "atk":
            value1 = card1.atkValue
            
            switch button2{
            case "atk":
                value2 = card2.atkValue
            case "def":
                value2 = card2.defValue
                
                //Bonus for Player 2
                value2 += calculateBonus(card: card2, deckCount: deckCount2)
            case "int":
                value2 = card2.intValue
                
                //Bonus for Player 1
                value1 += calculateBonus(card: card1, deckCount: deckCount1)
            default:
                value2 = 0
            }
        case "def":
            value1 = card1.defValue
            
            switch button2{
            case "atk":
                value2 = card2.atkValue
                
                //Bonus for Player 1
                value1 += calculateBonus(card: card1, deckCount: deckCount1)
            case "def":
                value2 = card2.defValue
            case "int":
                value2 = card2.intValue
                
                //Bonus for Player 2
                value2 += calculateBonus(card: card2, deckCount: deckCount2)
            default:
                value2 = 0
            }
        case "int":
            value1 = card1.intValue
            
            switch button2{
            case "atk":
                value2 = card2.atkValue
                
                //Bonus for Player 2
                value2 += calculateBonus(card: card2, deckCount: deckCount2)
            case "def":
                value2 = card2.defValue
                
                //Bonus for Player 1
                value1 += calculateBonus(card: card1, deckCount: deckCount1)
            case "int":
                value2 = card2.intValue
            default:
                value2 = 0
            }
        default:
            value1 = 0
            
            switch button2{
            case "atk":
                value2 = card2.atkValue
            case "def":
                value2 = card2.defValue
            case "int":
                value2 = card2.intValue
            default:
                value2 = 0
            }
        }
        
        //Evaluate winner
        if(value1 > value2){
            //Player 1 won the round
            print("Player 1: \(value1) vs. Player 2: \(value2)")
            print("Winner: Player 1")
            return 1
            
        }else if(value1 < value2){
            //Player 2 won the round
            print("Player 1: \(value1) vs. Player 2: \(value2)")
            print("Winner: Player 2")
            return 2

        }else{
            //Draw - no player won
            print("Player 1: \(value1) vs. Player 2: \(value2)")
            print("Winner: Draw")
            return 0

        }
        
    }
    
    func calculateBonus(card: Card, deckCount: Int) -> Int{
        var bonusModifier: Int
        
        //Get bonus modifier based on rarity of a card
        switch card.rarity{
        case "Common":
            bonusModifier = 70
        case "Rare":
            bonusModifier = 50
        case "Epic":
            bonusModifier = 30
        case "Legendary":
            bonusModifier = 10
        default:
            bonusModifier = 0
        }
        
        //Calculate bonus
        let bonus = (Double(bonusModifier) / Double(deckCount))
        return Int(bonus.rounded())
    }
}
