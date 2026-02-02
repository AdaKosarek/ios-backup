//
//  GeminiService.swift
//  StudySync
//
//  Created by mp on 21.01.2026.
//

import Foundation

class GeminiService {
    
    private var apiKey: String {
            guard let key = Bundle.main.object(forInfoDictionaryKey: "GeminiAPIKey") as? String else {
                print("CHYBA: Klíč 'GeminiAPIKey' nebyl nalezen v Info.plist")
                return ""
            }
            return key
        }
    
    private let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    func generateAnswer(for question: String) async throws -> String {
        guard !apiKey.isEmpty else {
            print("CHYBA: Chybí API klíč")
            throw URLError(.userAuthenticationRequired)
        }
        
        guard let url = URL(string: "\(urlString)?key=\(apiKey)") else {
            throw URLError(.badURL)
        }
        
        let body: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": "Jsi pomocník pro studenty. Odpověz na tuto studijní otázku stručně, jasně a česky (maximálně 2 věty): \(question)"]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // --- DIAGNOSTIKA CHYBY 404 ---
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 404 {
                print("Model nenalezen. Spouštím diagnostiku dostupných modelů...")
                await listAvailableModels()
                
                throw URLError(.badServerResponse)
            }
            
            if httpResponse.statusCode != 200 {
                if let errorText = String(data: data, encoding: .utf8) {
                    print("CHYBA OD SERVERU (Kód \(httpResponse.statusCode)): \(errorText)")
                }
                throw URLError(.badServerResponse)
            }
        }
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
           let candidates = json["candidates"] as? [[String: Any]],
           let content = candidates.first?["content"] as? [String: Any],
           let parts = content["parts"] as? [[String: Any]],
           let text = parts.first?["text"] as? String {
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        throw URLError(.cannotParseResponse)
    }
    
    func listAvailableModels() async {
        print("🔍 Zjišťuji dostupné modely pro tvůj API klíč...")
        
        let listUrlString = "https://generativelanguage.googleapis.com/v1beta/models?key=\(apiKey)"
        guard let url = URL(string: listUrlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("SEZNAM MODELŮ OD GOOGLE:\n\(jsonString)")
            }
            
            // Zkusíme najít názvy pro snadnější čtení
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let models = json["models"] as? [[String: Any]] {
                print("NALEZENÉ MODELY (zkopíruj jeden z těchto názvů):")
                for model in models {
                    if let name = model["name"] as? String,
                       let methods = model["supportedGenerationMethods"] as? [String],
                       methods.contains("generateContent") { // Hledáme jen ty, co umí generovat text
                        print("   👉 \(name)")
                    }
                }
            }
        } catch {
            print("Nepodařilo se načíst seznam modelů: \(error)")
        }
    }
    
}

