//
//  HomeView.swift
//  HackDearborn3
//
//  Created by dmoney on 10/12/24.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Spacer()
            // Scan Bill Button
            Button(action: {
                // Action for scanning a bill
            }) {
                HStack {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    Text("Scan Bill")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 2))
            }
            .padding(.bottom, 20)

            // Or Enter Manually Text
            Text("or")
                .font(.title2)
                .foregroundColor(.gray)

            Text("Enter expense manually")
                .font(.title)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 10)
                .padding(.bottom, 50)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
