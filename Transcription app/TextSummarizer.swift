import Foundation
import NaturalLanguage

class TextSummarizer{
    func summarize(text: String) -> String {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        
        var sentences: [String] = []
        
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex ) {range, _ in
            let sentence = String(text[range]).trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !sentence.isEmpty {
                sentences.append(sentence)
            }
            
            return true
        }
        
        return sentences.prefix(2).joined(separator: " ")
    }
}
