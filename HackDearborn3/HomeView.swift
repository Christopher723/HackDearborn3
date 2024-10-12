//
//  HomeView.swift
//  HackDearborn3
//
//  Created by dmoney on 10/12/24.
//
import SwiftUI
import Vision
import VisionKit
import CoreML

struct HomeView: View {
    @State private var scannedText = ""
    @State private var isShowingScanner = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                // Scan Bill Button
                Button(action: {
                    // Action for scanning a bill
                    isShowingScanner = true
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
                
               
                
                NavigationLink {
                    ExpenseCategoryView()
                } label: {
                    Text("Enter expense manually")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        .padding(.bottom, 50)
                }

                
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingScanner) {
                ScannerView(scannedText: $scannedText)
            }
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
    HomeView()
}
