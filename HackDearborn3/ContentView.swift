

import SwiftUI
import Vision
import VisionKit
import CoreML

struct ContentView: View {
    @State private var scannedText = ""
    @State private var isShowingScanner = false

    var body: some View {
        VStack {
            Text("Scanned Items:")
                .font(.headline)
            ScrollView {
                Text(scannedText)
            }
            .frame(height: 300)
            .border(Color.gray, width: 1)

            Button("Scan Receipt") {
                isShowingScanner = true
            }
        }
        .padding()
        .sheet(isPresented: $isShowingScanner) {
            ScannerView(scannedText: $scannedText)
        }
    }
}

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = context.coordinator
        return scannerViewController
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(scannedText: $scannedText)
    }

    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        @Binding var scannedText: String

        init(scannedText: Binding<String>) {
            _scannedText = scannedText
        }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            guard scan.pageCount >= 1 else {
                controller.dismiss(animated: true)
                return
            }

            let image = scan.imageOfPage(at: 0)
            processImage(image)
            controller.dismiss(animated: true)
        }

        private func processImage(_ image: UIImage) {
            guard let cgImage = image.cgImage else { return }

            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }

                let recognizedStrings = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }

                DispatchQueue.main.async {
                    self?.scannedText = recognizedStrings.joined(separator: "\n")
                }
            }

            do {
                try requestHandler.perform([request])
            } catch {
                print("Failed to perform OCR: \(error)")
            }
        }
    }
}


#Preview {
    ContentView()
}
