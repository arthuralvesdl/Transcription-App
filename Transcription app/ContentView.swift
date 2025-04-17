import SwiftUI
import Speech

struct ContentView: View {
    @StateObject private var recognizer = SpeechRecognizer()
    
    let ia = TextSummarizer()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Texto:")
                .font(.headline)
            
            Text(recognizer.recognizedText)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
            
            Button(recognizer.recognizerIsRunning ? "Parar" : "Gravar áudio") {
                recognizer.start()
            }
            .padding()
        }
    }
}

