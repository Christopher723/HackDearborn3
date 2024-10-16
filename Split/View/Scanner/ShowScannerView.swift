

import SwiftUI

struct ShowScannerView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    @State private var showTutorialScreen = false
    @State private var showScanningResults = false
    @State private var nothingFound = false
    
    var body: some View {
        if showScanningResults {
            FirstListView(showScanningResults: $showScanningResults, nothingFound: $nothingFound)
        } else {
            HStack {
                if !showTutorialScreen {
                    ScannerView { result in
                        switch result {
                            case .success(let scannedImages):
                                let textRecognitionFunctions = TextRecognitionFunctions(model: model, recognizedContent: recognizedContent)
                            textRecognitionFunctions.fillInModel(images: scannedImages) { nothing in
                                nothingFound = nothing
                            }
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                        withAnimation() {
                            showScanningResults = true
                        }

                    } didCancelScanning: {
                        // Dismiss the scanner controller and the sheet.
                        withAnimation() {
                            model.eraseModelData(eraseScanFails: false)
                        }
                    }
                } else {
                    //black screen
                    HStack {
                        VStack{
                            Text("")
                            Spacer()
                        }
                        Spacer()
                    }
                    .background(.black)
                }
            }
            .onAppear(perform: {
                let secondsToDelay = 0.6
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showTutorialScreen = model.parameters.showScanTutorial
                }
            })
//            .transition(.move(edge: .bottom))
            
        }
    }
}

//struct ShowScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowScannerView()
//    }
//}
