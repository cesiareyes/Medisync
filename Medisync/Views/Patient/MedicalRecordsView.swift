//
//  MedicalRecordsView.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

enum PickerType: Identifiable {
    case photo, file
    var id: Int {
        hashValue
    }
}

struct MedicalRecordsView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(viewModel.medicalRecords) { record in
                    MedicalRecordCard(record: record)
                }
                UploadRecordButton(viewModel: viewModel)
            }
            .padding()
        }
    }
}

struct MedicalRecordCard: View {
    let record: MedicalRecord

    var body: some View {
        VStack(alignment: .leading) {
            Text(record.type.rawValue.capitalized)
                .font(.title3).bold()
                .foregroundColor(.white)
            Text("Date: \(record.date, style: .date)")
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .background(Color.black.opacity(0.2))
        .cornerRadius(15)
    }
}

/**
 * A struct for handling file and photo uploads from user's device
 * This code was adapted from a Youtube Video titled " 008 - Importing images, files, and contact cards into your app | SwiftUI" by scriptpapi, published on Feburary 19, 2023
 * https://www.youtube.com/watch?v=CcRk6Xew-iY
 */

struct UploadRecordButton: View {
    @State private var actionSheetVisible = false
    @State private var pickerType: PickerType?
    @State private var selectedType: PickerType?
    
    @State private var selectedImage: UIImage?
    @State private var selectedDocument: URL?
    @State private var selectedDocumentName: String?
    
    @ObservedObject var viewModel: PatientDashboardViewModel

    var body: some View {
        VStack {
            VStack {
                if self.selectedType == .photo, let selectedImage = self.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                }
                else if self.selectedType == .file, let selectedDocumentName = self.selectedDocumentName {
                    Text("Document selected: \(selectedDocumentName)")
                        .foregroundColor(.white)
                }
            }
            
            Button("Upload Medical Record") {
                self.actionSheetVisible = true
            }
            .confirmationDialog("Select a type", isPresented: self.$actionSheetVisible) {
                Button("Photo Library") {
                    self.pickerType = .photo
                    self.selectedType = .photo
                }
                Button("File") {
                    self.pickerType = .file
                    self.selectedType = .file
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
            .cornerRadius(15)
        }
        .padding()
        .foregroundColor(.white)
        .sheet(item: self.$pickerType, onDismiss: { print("dismiss") }) { item in
            switch item {
            case .photo:
                ImagePicker(image: self.$selectedImage)
            
            case .file:
                DocumentPicker(filePath: self.$selectedDocument)
            }
        }
        .onChange(of: selectedImage) { _ in
            if let selectedImage = self.selectedImage {
                uploadImageToFirebase(image: selectedImage)
            }
        }
        .onChange(of: selectedDocument) { _ in
            if let selectedDocument = self.selectedDocument {
                uploadDocumentToFirebase(documentURL: selectedDocument)
            }
        }
    }
    
    func uploadImageToFirebase(image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let storageReference = Storage.storage().reference().child("medical_records/\(UUID().uuidString).jpg")
        
        storageReference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            storageReference.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                if let url = url {
                    saveMedicalRecordURLToFirestore(fileURL: url.absoluteString)
                }
            }
        }
    }
    
    func uploadDocumentToFirebase(documentURL: URL) {
        let storageReference = Storage.storage().reference().child("medical_records/\(UUID().uuidString).pdf")
        
        storageReference.putFile(from: documentURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading document: \(error.localizedDescription)")
                return
            }
            
            storageReference.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                if let url = url {
                    saveMedicalRecordURLToFirestore(fileURL: url.absoluteString)
                }
            }
        }
    }
    
    func saveMedicalRecordURLToFirestore(fileURL: String) {
        if let userID = viewModel.currentUserID {
            let firestoreRef = Firestore.firestore().collection("users").document(userID)
            
            firestoreRef.updateData([
                "medicalRecords": FieldValue.arrayUnion([fileURL])
            ]) { error in
                if let error = error {
                    print("Error saving medical record URL: \(error.localizedDescription)")
                } else {
                    print("Medical record URL saved successfully")
                }
            }
        } else {
            print("No user logged in")
        }
    }
}


#Preview {
    MedicalRecordsView(viewModel: PatientDashboardViewModel())
}
