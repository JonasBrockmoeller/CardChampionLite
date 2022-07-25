//
//  WinnerView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 18.05.22.
//
import SwiftUI
import ConfettiSwiftUI
import SSSwiftUIGIFView

struct WinnerView: View {
    @Binding var isPresented: Bool
    let wins: Int
    let lost: Int
    @State var confetti: Int = 0
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                
                Button("close"){
                    isPresented.toggle()
                }
                .padding(.trailing)
            }
            
            Spacer()
            
            Text("You won!")
                .font(.title.bold())
                .padding()
            
            Text("Rounds won: \(wins)")
            Text("Rounds lost: \(lost)")
                .confettiCannon(counter: $confetti, radius: 400, repetitions: 5, repetitionInterval: 0.5)
            
            SwiftUIGIFPlayerView(gifName: "winner")
                .frame(width: 350, height: 250)
                .cornerRadius(15)
            
            Spacer()
        }
        .onAppear(){
            self.confetti += 1
        }
        .onTapGesture {
            self.confetti += 1
        }
    }
}

/*
struct WinnerView_Previews: PreviewProvider {
    static var previews: some View {
        WinnerView(wins: 4, lost: 1)
    }
}
*/
