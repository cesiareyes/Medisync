//
//  HomeView.swift
//  Medisync
//
//  Created by Cesia Reyes on 10/1/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Welcome to MediSync!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding()
            .padding(.bottom, 40)
        
        Text("Our Goal:")
            .font(.title)
        Text("MediSync is striving to create an easier option for medical staff and patients to speed up the process of check-ins in medical facilities.")
            .padding()
        
        Text("Why:")
            .font(.title)
        Text("Typically when going to the ER the wait time is around 15 or more minutes just to be seen. There are a plethora of health risk that can drastically escalte such as; Blood clotting, seizures, and many more. MediSync will allow nurses/doctors to see whos coming in for what so they already have a better idea of how to treat that patients needs.")
            .padding()
    }
}

#Preview {
    HomeView()
}
