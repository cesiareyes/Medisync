//
//  DocumentPicker.swift
//  Medisync
//
//  Created by Cesia Reyes on 12/13/24.
//

/**
 * A struct that provides the abililty to select a document from the user's device
 * This code is from a Github Gist post:
 * https://gist.github.com/scriptpapi/d4d2647aedd761831eeaf1450c299887
 */

import Foundation
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var filePath: URL?
    
    func makeCoordinator() -> DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: DocumentPicker.UIViewControllerType, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker){
            parent = parent1
        }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.filePath = urls[0]
            print(urls[0].absoluteString)
        }
    }
}
