

import SwiftUI


struct ContentView: View {
 
    var body: some View {
        VStack {
            Text("Scanned Items:")
                .font(.headline)
            ScrollView {
//                Text(scannedText)
            }
            .frame(height: 300)
            .border(Color.gray, width: 1)

            Button("Scan Receipt") {
//                isShowingScanner = true
            }
        }
        .padding()
//        .sheet(isPresented: $isShowingScanner) {
//            ScannerView(scannedText: $scannedText)
//        }
    }
}




#Preview {
    ContentView()
}
