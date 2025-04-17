import SwiftUI
import Speech

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()

    var body: some View {
        VStack(spacing: 20) {
            Text("Texto:")
                .font(.headline)
            
            if recognizer.recognizerIsRunning {
                ProgressView()
            }
            else if !recognizer.recognizedText.isEmpty && !recognizer.recognizerIsRunning {
                Text(recognizer.recognizedText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
            } else if recognizer.errorMessage != nil && !recognizer.recognizerIsRunning{
                Text(recognizer.errorMessage!)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .foregroundColor(.red)
            }
            
            Button(recognizer.recognizerIsRunning ? "Parar" : "Gravar áudio") {
                recognizer.start()
            }
            .padding()
        }
    }
}

