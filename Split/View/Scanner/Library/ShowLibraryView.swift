

import SwiftUI
import PhotosUI

struct ShowLibraryView: View {
    @EnvironmentObject var model: ModelData
    @ObservedObject var recognizedContent = TextData()
    
    @State private var selectedImages: [UIImage] = []
    
    @Binding var nothingFound: Bool
    @Binding var showResults: Bool
    @Binding var showSheet: Bool
    
    @State private var showTutorialScreen = false
    
    var body: some View {
            ImagePicker(images: $selectedImages) {
                withAnimation() {
                    model.eraseModelData(eraseScanFails: false, fast: true)
                }
            } onDone: {
                let textRecognitionFunctions = TextRecognitionFunctions(model: model, recognizedContent: recognizedContent)
                textRecognitionFunctions.fillInModel(images: selectedImages) { nothing in
                    nothingFound = nothing
                }
                withAnimation() {
                    showResults = true
                    showSheet = false
                }
            }
            .onAppear {
                selectedImages = [] // re-initialize when the user goes back to this interface after having cancelled the next step
            }
            .onAppear(perform: {
                let secondsToDelay = 0.6
                DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
                    showTutorialScreen = model.parameters.showLibraryTutorial
                }
            })
            
    }
}

struct ShowLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        ShowLibraryView(nothingFound: .constant(false), showResults: .constant(false), showSheet: .constant(false))
            .environmentObject(ModelData())
    }
}
