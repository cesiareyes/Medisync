//
//  DashboardTabItem.swift
//  Medisync
//
//  Created by Chelsea Roque on 11/19/24.
//

import SwiftUI

struct DashboardTabItem: View {
    let icon: String
    let label: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(isSelected ? Color("Primary") : Color("Secondary"))
            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(isSelected ? Color("Primary") : Color("Secondary"))
        }
    }
}
