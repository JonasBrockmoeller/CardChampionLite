//
//  Intro.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 12.05.22.
//
/*
 Rotato settings:
 Phone: Iphone 12 Pro
 Frame: 3.5 inch -> Iphone 4
 Pos: x:0, y: -1, z: 29.4
 Rotation: x: 10, y: 12, z:7
 Background: clear
 */

import SwiftUI

struct Intro: View {
    @State var counter = 0
    
    var body: some View {
        VStack{
                if counter == 0{
                    IntroCards(nextView: $counter)
                } else if counter == 1{
                    IntroAttributes(nextView: $counter)
                } else if counter == 2{
                    IntroBonus(nextView: $counter)
                } else if counter == 3{
                    IntroMap(nextView: $counter)
                } else if counter == 4{
                    IntroDeck(nextView: $counter)
                } else if counter == 5{
                    IntroGame(nextView: $counter)
                } else {
                    MainView()
                }
        }
    }
}

struct Intro_Previews: PreviewProvider {
    static var previews: some View {
        Intro()
    }
}
