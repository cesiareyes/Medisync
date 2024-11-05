import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to MediSync!")
                .font(.system(size: 34, weight: .semibold, design: .default)) // San Francisco
                .padding()
                .padding(.bottom, 40)
            
            Text("Our Goal:")
                .font(.system(size: 24, weight: .bold, design: .default)) // San Francisco
            
            Text("MediSync is striving to create an easier option for medical staff and patients to speed up the process of check-ins in medical facilities.")
                .font(.system(size: 16, design: .default)) // San Francisco
                .padding()
            
            Text("Why:")
                .font(.system(size: 24, weight: .bold, design: .default)) // San Francisco
            
            Text("Typically when going to the ER the wait time is around 15 or more minutes just to be seen. There are a plethora of health risks that can drastically escalate such as; Blood clotting, seizures, and many more. MediSync will allow nurses/doctors to see who's coming in for what so they already have a better idea of how to treat that patient's needs.")
                .font(.system(size: 16, design: .default)) // San Francisco
                .padding()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
