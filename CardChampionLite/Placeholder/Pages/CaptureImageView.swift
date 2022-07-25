//
//  cameraView.swift
//  Placeholder
//
//  Created by Jannik Schwerdtner on 21.04.22.
//

import SwiftUI



struct CaptureImageView {
    @Binding var isShown: Bool
    @Binding var image: UIImage?

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, image: $image)
    }
}
extension CaptureImageView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<CaptureImageView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<CaptureImageView>) {

    }
}

