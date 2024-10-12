import SwiftUI

struct ExpenseCategoryView: View {

    // Array of expense categories represented by emojis
    let categories = [
        ("🍕🍻", "Food & Drinks"),
        ("🏠🧾", "Housing"),
        ("🚗💨", "Transportation")
    ]

    var body: some View {
        VStack {
            // Header text asking the user what kind of expense
            Text("What kind of expense?")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)
                .padding(.top, 20)

            Spacer()

            // List of categories with emojis
            ForEach(categories, id: \.1) { category in
                HStack {
                    Text(category.0)
                        .font(.system(size: 50)) // Emoji size
                        .padding(.trailing, 20)
                    Text(category.1)
                        .font(.title)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)
            }

            Spacer()
        }
    }
}

#Preview{
    ExpenseCategoryView()
}
