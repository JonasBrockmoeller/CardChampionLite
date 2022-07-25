//
//  ContentView.swift
//  CardDesign_Experiment
//
//  Created by Tim Weigand on 31.03.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let darthVader = Card(id: 12, cardName: "Darth Vader", imagePath: "DarthVader", atkValue: 50, defValue: 50, intValue: 50, rarity: "Legendary").scaleEffect(0.9)
    
        VStack(alignment: .trailing, spacing: -455){
            HStack (alignment: .center, spacing: -315){
                darthVader
           /*     darthVader
                darthVader
            }
           HStack (alignment: .center, spacing: -315){
                darthVader
                darthVader
                darthVader
            }
            HStack (alignment: .center, spacing: -315){
                darthVader
                darthVader
                darthVader*/
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
