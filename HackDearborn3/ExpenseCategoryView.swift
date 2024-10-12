import SwiftUI

struct ExpenseCategoryView: View {

    // Array of expense categories represented by emojis
    let categories = [
        ("🍕🍻", "Food & Drinks", AnyView(FoodSplitView())),
        ("🏠🧾", "Housing", AnyView(HouseSplitView())),
        ("🚗💨", "Transportation", AnyView(RideSplitView()))
    ]

    var body: some View {
        NavigationView {
            VStack {
           
                Text("What kind of expense?")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 20)

                Spacer()

                ForEach(categories, id: \.1) { category in
                    NavigationLink(destination: category.2) {
                        HStack {
                            Text(category.0)
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                            Text(category.1)
                                .font(.title)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
        }
    }
}

#Preview{
    ExpenseCategoryView()
}

