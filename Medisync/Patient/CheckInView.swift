//
//  CheckInView.swift
//  Medisync
//
//  Created by Cesia Reyes on 11/7/24.
//

import SwiftUI

struct CheckInView: View {
    @ObservedObject var queueManager: QueueManager

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Enter the queue for your appointment.")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .cornerRadius(10)
                    .foregroundColor(.black)

                if queueManager.userInQueue {
                    Text("You are in the queue!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.top)
                    Text("You are number \(queueManager.userPosition!) in line.")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.black)
                    Text("\(queueManager.queueCount - 1) people ahead of you.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                } else {
                    Text("No one is currently in the queue.")
                        .font(.title3)
                        .padding(.bottom)
                        .foregroundColor(.gray)
                }

                if !queueManager.userInQueue {
                    Button("Check-In Now") {
                        queueManager.checkInUser()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.8))
                    .cornerRadius(15)
                } else {
                    Button("Leave Queue") {
                        queueManager.nextInQueue()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(15)
                }
            }
            .padding()
        }
    }
}


#Preview {
    CheckInView(queueManager: QueueManager())
}
