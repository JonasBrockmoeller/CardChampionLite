//
//  LoadingView.swift
//  Placeholder
//
//  Created by Sebastian Wedekind on 06.04.22.
//

import SwiftUI

struct LoadingView: View {
    @State var animate = false;
    @State var endSplash = false;
    
    var body: some View {
        ZStack{
            
            LoginView()
            
            ZStack{
                Color("loadingColor")
                Image("LoadingIcon")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 85, height: animate ? nil :85)
                
                    .scaleEffect(animate ? 3 : 1)
                
                    .frame(width: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            .opacity(endSplash ? 0 : 1)
        }
    }
    
    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
            withAnimation(Animation.easeOut(duration: 1.5)){
                animate.toggle()
            }
            withAnimation(Animation.linear(duration: 1)){
                endSplash.toggle()
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
