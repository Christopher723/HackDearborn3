import SwiftUI

struct StartView: View {

    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass //for iPad specificity
    
    @State private var names: [String] = []
    @State private var currencyType = Currency.default.symbol
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showAlert3 = false
    @State private var showSettings = false
    @State private var showHistoryView = false
    @State private var showFavoriteView = false
    @State var photoLibrarySheet = false
    @State var filesSheet = false
    
    @State private var showResults = false
    @State private var nothingFound = false
    @State private var newUserName: String = ""
        
    var body: some View {
        
        if model.startTheProcess && !model.photoIsImported {
            ShowScannerView()
        } else if model.startTheProcess && model.photoIsImported && showResults {
            FirstListView(showScanningResults: $showResults, nothingFound: $nothingFound)
        } else {
            
            let formDetails = FormDetailsView(names: $names, newUserName: $newUserName, currencyType: $currencyType, showAlert1: $showAlert1, showAlert2: $showAlert2)
            
            NavigationView {
                ZStack {
                    // Background color
                    Color("mBlue")
                        .ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("PayUp")
                            .font(.largeTitle.bold())
                            .foregroundStyle(Color("mBlue"))
                            .padding()
                            .background(Color("mYellow"))
                            .cornerRadius(32)
                        formDetails
                    }
                    .padding()
                    .background(Color("mBlue")) // Apply the same background color here for consistency
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            
                            Group {
                                Button {
                                    let ok = formDetails.isFinalUsersCorrect()
                                    if ok {
                                        ParametersStore.load { result in
                                            switch result {
                                            case .failure(let error):
                                                fatalError(error.localizedDescription)
                                            case .success(let parameters):
                                                model.parameters = parameters
                                            }
                                        }
                                        for name in names {
                                            model.users.append(User(name: name))
                                        }
                                        model.currency = Currency(symbol: currencyType)
                                        withAnimation {
                                            model.startTheProcess = true
                                        }
                                    }
                                } label: {
                                    StartCustomButtons(role: "scan")
                                }
                            }
                            .padding(.horizontal, 6)
                            .disabled(names.isEmpty || (!model.startTheProcess && !model.users.isEmpty)) 
                            .onTapGesture {
                                if names.isEmpty {
                                    showAlert3 = true
                                }
                            }
                            .alert(isPresented: $showAlert3) {
                                Alert(title: Text("No users"), message: Text("Please add the name of at least one user to start"), dismissButton: .default(Text("OK")))
                            }
                            .buttonStyle(.plain)
                            
                            Spacer()
                        }
                    }
                    
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(ModelData())
    }
}
