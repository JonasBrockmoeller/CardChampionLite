//
//  LooserView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 18.05.22.
//

import SwiftUI
import SSSwiftUIGIFView

struct LooserView: View {
    @Binding var isPresented: Bool
    let wins: Int
    let lost: Int
    
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
            
            Text("You lost!")
                .font(.title.bold())
                .padding()
            
            Text("Rounds won: \(wins)")
            Text("Rounds lost: \(lost)")
            
            SwiftUIGIFPlayerView(gifName: "looser")
                .frame(width: 350, height: 250)
                .cornerRadius(15)
            
            Spacer()
        }
    }
}

/*
struct LooserView_Previews: PreviewProvider {
    static var previews: some View {
        LooserView()
    }
}
 */
