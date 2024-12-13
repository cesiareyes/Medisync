//
//  AddPatientForm.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/19/24.
//

import SwiftUI
import FirebaseFirestore

struct AddPatientForm: View {
    @ObservedObject var viewModel: NurseDashboardViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var newPatient = Patient(
        name: "",
        age: 0,
        bloodType: "",
        height: nil,
        weight: nil,
        symptoms: [],
        medications: "",
        immunizations: "",
        dateOfBirth: Date()
    )

    @State private var symptomDuration: String = ""
    @State private var symptomDescription: String = ""
    @State private var selectedSymptom: Symptom? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Patient Information")
                    .font(.headline)
                
                TextField("Name", text: $newPatient.name)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                DatePicker("Date of Birth", selection: $newPatient.dateOfBirth, displayedComponents: .date)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Blood Type", text: $newPatient.bloodType)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Height (in)", value: $newPatient.height, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Weight (lbs)", value: $newPatient.weight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Medications", text: $newPatient.medications)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                TextField("Immunization History", text: $newPatient.immunizations)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                
                HStack {
                    Text("Select Symptom: ")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    Picker("Symptom", selection: $selectedSymptom) {
                        ForEach(Symptom.allCases, id: \.self) { symptom in
                            Text(symptom.rawValue.capitalized).tag(symptom as Symptom?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .accentColor(.black)
                }

                VStack(alignment: .leading) {
                    Text("How long has patient had this symptom? ")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    TextField("Enter duration (e.g., 2 days, 1 week)", text: $symptomDuration)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)
                        .keyboardType(.default)
                }
                
                VStack(alignment: .leading) {
                    Text("Describe the symptom in more detail:")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    
                    TextField("Add a brief description", text: $symptomDescription)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(8)
                        .shadow(radius: 5)
                        .keyboardType(.default)
                }
                
                Button(action: {
                    savePatient()
                }) {
                    Text("Add Patient")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
                        .cornerRadius(15)
                        .padding(.top, 20)
                }

            }
            .padding()
        }
    }
    
    // Save patient details to Firestore
    private func savePatient() {
        guard let nurseUID = try? AuthenticationManager.shared.getAuthenticatedUser().uid else {
            print("No logged-in nurse")
            return
        }
        
        let patientData: [String: Any] = [
            "name": newPatient.name,
            "age": calculateAge(from: newPatient.dateOfBirth),
            "bloodType": newPatient.bloodType,
            "height": newPatient.height ?? 0,
            "weight": newPatient.weight ?? 0,
            "symptoms": selectedSymptom != nil ? [
                "symptom": selectedSymptom!.rawValue,
                "duration": symptomDuration,
                "description": symptomDescription
            ] : [],
            "medications": newPatient.medications,
            "immunizations": newPatient.immunizations
        ]
        
        let db = Firestore.firestore()
        let nurseRef = db.collection("nurses").document(nurseUID)
        
        nurseRef.collection("patients").addDocument(data: patientData) { error in
            if let error = error {
                print("Error saving patient: \(error)")
            } else {
                print("Patient saved successfully")
                viewModel.fetchPatients()
                resetForm()
                dismiss()
            }
        }
    }
    
    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
    
    private func resetForm() {
        newPatient = Patient(name: "", age: 0, bloodType: "", height: nil, weight: nil, symptoms: [], medications: "", immunizations: "")
    }
}
