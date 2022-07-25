//
//  LoginView.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 28.04.22.
//

import SwiftUI
import SSSwiftUIGIFView

struct LoginView: View {
    var screenWidth = UIScreen.main.bounds.size.width
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var logInIsShown: Bool = true
    @State private var buttonLabel: String = "Register here"
    @State private var sectionLabel:String = "Want to create a profile?"
    @State private var showNextView: Bool = false
    @State private var showNextViewAfterRegister: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack(){
            HStack{
                Spacer(minLength: screenWidth * 0.25)
                Image("Banner")
                    .scaleEffect(0.3)
                    .frame(height: 80)
                Spacer()
            }.frame(width: screenWidth)
            
            Form{
                if logInIsShown{
                    getFormView(label: "Login")
                } else {
                    getFormView(label: "Register")
                }
                
                Section(sectionLabel){
                    HStack {
                        Spacer()
                        
                        Button{
                            logInIsShown.toggle()
                            
                            changeLabels()
                        }label: {
                            Text(buttonLabel)
                        }
                        
                        Spacer()
                    }
                }
            }
            .onAppear {
                UIScrollView.appearance().isScrollEnabled = false
                UIScrollView.appearance().backgroundColor = .clear
            }
            .frame(width: UIScreen.main.bounds.width, height: 300)
            
            SwiftUIGIFPlayerView(gifName: "waiting")
                .padding(.top)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $showNextView){
            MainView()
        }
        .fullScreenCover(isPresented: $showNextViewAfterRegister){
            Intro()
        }
    }
    
    func getFormView(label: String) -> some View {
        Section(header: Text(label)){
            TextField("Username", text: $username)
            
            SecureField("Password", text: $password)
            
            HStack {
                Spacer()
                
                Button{
                    if logInIsShown{
                        self.showNextView = true
                    } else{
                        self.showNextViewAfterRegister = true
                    }
                }label: {
                    Text(label)
                }
                
                Spacer()
            }
        }
    }
    
    func changeLabels(){
        if buttonLabel == "Register here"{
            buttonLabel = "Login here"
        } else{
            buttonLabel = "Register here"
        }
        
        if sectionLabel == "Already have a profile?"{
            sectionLabel = "Want to create a profile?"
        } else {
            sectionLabel = "Already have a profile?"
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
