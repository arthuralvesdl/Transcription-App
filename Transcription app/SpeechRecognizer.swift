import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
    private let recognizer = SFSpeechRecognizer(locale:Locale(identifier:  Locale.preferredLanguages.first ?? Locale.current.identifier) )
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var recognizedText: String = ""
    @Published var recognizerIsRunning = false
    @Published var volumeLevel: Float = 0.0

    func start() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                guard authStatus == .authorized else {
                    print("Permissão negada")
                    return
                }
                if self.recognizerIsRunning {
                    self.stop()
                } else {
                    self.startRecognition()
                }
            }
        }
    }
    
    private func startRecognition() {
        if audioEngine.isRunning {
            stop()
        }
        recognizerIsRunning = true
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        
        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)
        
        node.removeTap(onBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in recognitionRequest.append(buffer)
        }
        
        try? audioEngine.start()
        
        recognitionTask = recognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result, result.isFinal {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
                self.stop()
            }
            if let error = error {
                print("Erro: \(error.localizedDescription)")
                self.stop()
            }
        }
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.finish()
        recognitionTask = nil
        recognitionRequest = nil
        recognizerIsRunning = false
    }
}
