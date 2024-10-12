//
//  ExpenseDetailView.swift
//  HackDearborn3
//
//  Created by dmoney on 10/12/24.
//
import SwiftUI

struct ExpenseDetailView: View {
    @State var selectedCategory: String // or use an enum for expense types

    var body: some View {
        VStack {
            switch selectedCategory {
            case "Food & Drinks":
                FoodSplitView()
            case "Housing":
                HouseSplitView()
            case "Ride":
                RideSplitView()
            default:
                EmptyView()
            }
        }
    }
}
