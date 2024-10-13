import SwiftUI

struct FormDetailsView: View {
    
    @Binding var names: [String]
    @Binding var newUserName: String
    @Binding var currencyType: Currency.SymbolType
    @Binding var showAlert1: Bool
    @Binding var showAlert2: Bool
    
    var body: some View {
        ZStack {
            // Background color
            Color("mBlue")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Users")
                        .foregroundColor(Color("mYellow"))
                        .font(.title.bold())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Currency Picker
                    Menu {
                        Picker("Currency", selection: $currencyType.animation()) {
                            ForEach(Currency.SymbolType.allCases, id: \.self) { currencyType in
                                Text(Currency(symbol: currencyType).value)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("mYellow"))
                                    .cornerRadius(32)
                            }
                        }
                    } label: {
                        HStack {
                            Text("Currency: \(Currency(symbol: currencyType).value)")
                                .foregroundColor(Color("mBlue"))
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color("mBlue"))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("mYellow"))
                        .cornerRadius(32)
                    }
                    .onAppear {
                        ParametersStore.load { result in
                            switch result {
                            case .failure(let error):
                                fatalError(error.localizedDescription)
                            case .success(let parameters):
                                if names.isEmpty && newUserName.isEmpty {
                                    currencyType = parameters.defaultCurrency.symbol
                                }
                            }
                        }
                    }
                    
                    // List of Names
                    ForEach(names, id: \.self) { name in
                        Text(name)
                            .foregroundColor(Color("mBlue"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("mYellow"))
                            .cornerRadius(32)
                            .shadow(radius: 10, x: 0, y: 10)
                    }
                    .onDelete { indices in
                        withAnimation {
                            names.remove(atOffsets: indices)
                        }
                    }
                    
                    // New User TextField
                    TextField("New user", text: $newUserName)
                        .foregroundColor(Color("mBlue"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("mYellow"))
                        .cornerRadius(24)
                        .shadow(radius: 10, x: 0, y: 10)
                    
                    // Add Button
                    Button(action: {
                        let _ = checkAndAddName()
                    }) {
                        Text("Add")
                            .foregroundColor(Color("mBlue"))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(Color("mYellow"))
                            .cornerRadius(24)
                            .shadow(radius: 10, x: 0, y: 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(newUserName.isEmpty)
                }
                .padding()
            }
        }
    }
    
    func checkAndAddName() -> Bool {
        let realName = newUserName.trimmingCharacters(in: .whitespaces)
        if !realName.isEmpty {
            if !names.contains(realName) {
                withAnimation {
                    names.append(realName)
                }
                newUserName = ""
                return true
            } else {
                showAlert2 = true
            }
        } else {
            showAlert1 = true
        }
        return false
    }
    
    func isFinalUsersCorrect() -> Bool {
        // Ensure new user is added before proceeding if it’s not empty
        if !newUserName.isEmpty {
            return checkAndAddName()
        }
        return true
    }
}

struct FormDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        FormDetailsView(
            names: .constant(["Hugo", "Thomas"]),
            newUserName: .constant("Lucas"),
            currencyType: .constant(Currency.SymbolType.euro),
            showAlert1: .constant(false),
            showAlert2: .constant(false)
        )
    }
}
