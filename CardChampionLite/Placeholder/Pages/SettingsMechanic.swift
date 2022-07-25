//
// Created by Sebastian Wedekind on 26.04.22.
//

import Foundation
import UIKit


class SettingsMechanic{
    let userDefaults = UserDefaults.standard


    func checkNewPasswords(inputNewPassword : String, inputCheckPassword : String ) -> Bool{
        return inputNewPassword == inputCheckPassword
    }

    
    func saveImage(imageName: String, image: UIImage) {

        let fileName = imageName
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
            print(fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
}
