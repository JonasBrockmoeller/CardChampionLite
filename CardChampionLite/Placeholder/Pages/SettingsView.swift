//
//  SettingsView.swift
//  Placeholder
//
//  Created by Sebastian Wedekind on 06.04.22.
//

import SwiftUI


struct SettingsView: View {
    var screenWidth = UIScreen.main.bounds.size.width
    var screenHeight = UIScreen.main.bounds.size.height
    var screenSize = UIScreen.main.bounds.size

    @Binding public var isPresented: Bool

    @State public var newprofilename: String = ""
    @State public var currentPassword: String = ""
    @State public var newPassword: String = ""
    @State public var checkNewPassword: String = ""
    @State private var notificationStatus = true;
    @State private var checkPasswords = false;
    @State private var locationStatus = true;
    @State private var cameraStatus = true;
    @State private var showCaptureImageView = false;
    @State var image: UIImage? = nil;

    var body: some View {
        Capsule()
            .fill(.gray)
            .frame(width: 40, height: 7)
            .padding(.top)
                
        NavigationView {
            Form {
                Section {
                    Button {
                        self.showCaptureImageView.toggle()
                    } label: {
                        if let uiImage = image {
                            Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                                    .sheet(isPresented: $showCaptureImageView) {
                                        CaptureImageView(isShown: $showCaptureImageView, image: $image);
                                    }
                            
                        } else {
                            Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .foregroundColor(CustomColors.buttonColor)
                                    .sheet(isPresented: $showCaptureImageView) {
                                        CaptureImageView(isShown: $showCaptureImageView, image: $image);
                                    }
                        }
                    }

                }
                Section(header: Text("Profile")) {
                    TextField("New profile name", text: $newprofilename)
                            .font(.system(size: 20))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)

                }
                Section(header: Text("Password")) {
                    TextField("Input current password", text: $currentPassword)
                            .font(.system(size: 20))
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    
                    if (checkPasswords) {
                        TextField("Input new password", text: $newPassword)
                                .font(.system(size: 20))
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                                .onSubmit() {
                                    print("nice")
                                }

                        TextField("Input new password", text: $checkNewPassword)
                                .font(.system(size: 20))
                                .textInputAutocapitalization(.never)
                                .disableAutocorrection(true)
                    }
                }
                Section() {
                    HStack {
                        Spacer()
                        Button {
                        
                        }
                        label: {
                            Text("Save")
                        }
                        Spacer()
                    }
                }
                        .font(.system(size: screenWidth * 0.05))
            }
                    .navigationBarTitle(Text("USERNAME"))
        }

    }
}


func loadImageFromDiskWith(fileName: String) -> UIImage? {

    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

    if let dirPath = paths.first {
        let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: imageUrl.path)
        return image
    }
    return nil
}

/*
 struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
                .environmentObject(CredentialsModel())
    }
}*/
