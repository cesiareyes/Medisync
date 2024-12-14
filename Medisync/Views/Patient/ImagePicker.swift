//
//  ImagePicker.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/13/24.
//

/**
 * A struct that provides the ability to select an image from the user's device
 * This code is from a Github Gist post from scriptpapi:
 * https://gist.github.com/scriptpapi/01a35cda92066bddcf56cd17375e8679
 */

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage

            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
}
