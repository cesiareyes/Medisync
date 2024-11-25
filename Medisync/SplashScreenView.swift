//
//  SplashScreenView.swift
//  Medisync
//
//  Created by Will Terry on 10/14/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        
        if isActive {
            ContentView()
        }
        else {
            VStack {
                VStack{
                    Image("Medisync_Logo")
                        .resizable()
                        .frame(width: 400, height: 400) //Size of Logo
                        .rotationEffect(.degrees(rotationAngle))//Rotation
                        .onAppear {
                            //Logo Spin
                            withAnimation(
                                .default
                            ) {
                                self.rotationAngle = 360
                            }
                        }
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all) // Ensure gradient fills entire screen
            )
        }
    }
}

#Preview {
    SplashScreenView()
}
