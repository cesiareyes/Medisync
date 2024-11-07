//
//  SymptomsView.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import SwiftUI

struct SymptomsView: View {
    @ObservedObject var viewModel: PatientDashboardViewModel
    @State private var selectedSymptom: Symptom? = nil
    @State private var symptomDuration: String = ""
    @State private var symptomDescription: String = ""
    @State private var symptoms = Symptom.allCases

    var body: some View {
        VStack {
            Text("Symptom Tracker")
                .font(.system(size: 25, weight: .semibold, design: .default))
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("Select Symptom: ")
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 10)
                
                Picker("Symptom", selection: $selectedSymptom) {
                    ForEach(symptoms, id: \.self) { symptom in
                        Text(symptom.rawValue.capitalized).tag(symptom as Symptom?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .cornerRadius(8)
                .shadow(radius: 5)
                .accentColor(.black)
            }
            
            VStack(alignment: .leading) {
                Text("How long have you had this symptom? ")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 20)

                TextField("Enter duration (e.g., 2 days, 1 week)", text: $symptomDuration)
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .keyboardType(.default)
            }
            
            VStack(alignment: .leading) {
                Text("Describe the symptom in more detail:")
                    .font(.system(size: 18, weight: .semibold, design: .default))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                TextField("Add a brief description", text: $symptomDescription)
                    .padding()
                    .frame(width: 360, height: 60)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .keyboardType(.default)
            }
            
            AddSymptomButton {
                addSymptom()
            }
            Spacer()
        }
        .padding()
    }
    
    private func addSymptom() {
        guard let symptom = selectedSymptom, !symptomDuration.isEmpty else {
            return
        }
        
        let newSymptom = SymptomDetail(symptom: symptom, duration: symptomDuration, description: symptomDescription)
        viewModel.logSymptom(symptom: newSymptom)
        
        selectedSymptom = nil
        symptomDuration = ""
        symptomDescription = ""
    }
    
}

struct AddSymptomButton: View {
    var action: () -> Void
    
    var body: some View {
        Button("Add Symptom") {
            action()
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(red: 0.0, green: 0.13, blue: 0.27).opacity(0.9))
        .cornerRadius(15)
        .padding(.top, 20)
    }
}


#Preview {
    SymptomsView(viewModel: PatientDashboardViewModel())
}
