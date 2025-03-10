//
//  AnalysisPage.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 08/09/1446 AH.

import SwiftUI
import GoogleGenerativeAI
import CryptoKit

extension UIImage {
    func sha256() -> String? {
        guard let data = self.pngData() else { return nil }
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

struct AnalysisPage: View {
    @EnvironmentObject var sheetData: Model
    var capturedImage: UIImage?
    @State private var isLoading: Bool = false
    @State private var analysisCache: [String: String] = [:]
    
    // رابط الريسورس الخاص بالكتب المحملة.
    let downloadedBooks: String = "https://play.google.com/books/reader?id=RL79DwAAQBAJ&pg=GBS.PT30&hl=en_GB"
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)

    var body: some View {
        ZStack {
            Color.teal.opacity(0.1)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
            
                if let capturedImage = sheetData.capturedImage {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(10)
                } else {
                    Text("لا توجد صورة لعرضها")
                        .foregroundColor(.gray)
                }
                
                // عرض بيانات إضافية
                ////                Text("اسم الصورة: \(sheetData.imageName)")
                //                Text("عمر الطفل: \(sheetData.selectedAge)")
                //                  if isLoading {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
                        .scaleEffect(1)
                }
                ScrollView {
                    Text(sheetData.analysisResult)
                        .font(.subheadline)
                        .padding(.horizontal)
                }
                .frame(maxHeight: 150)
                
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
            
//            if isLoading {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle(tint: .indigo))
//                    .scaleEffect(1)
//            }
        }
        .onAppear {
            // إذا لم تكن نتيجة التحليل موجودة، قم بتحليل الصورة.
            if sheetData.analysisResult.isEmpty, let image = sheetData.capturedImage {
                analyzeImage(image, childAge: sheetData.selectedAge)
            }
        }
    }
    
    // دالة تحليل الصورة مع تمرير الصورة وعمر الطفل
    func analyzeImage(_ image: UIImage, childAge: String) {
        guard let imageHash = image.sha256() else {
            DispatchQueue.main.async { sheetData.analysisResult = "فشل في حساب بصمة الصورة." }
            return
        }
        
        if let cachedResult = analysisCache[imageHash] {
            DispatchQueue.main.async { sheetData.analysisResult = cachedResult }
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.3)?.base64EncodedString() else {
            DispatchQueue.main.async { sheetData.analysisResult = "تعذر تحويل الصورة إلى بيانات" }
            return
        }
        
        let apiKey = APIKey.default
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { sheetData.analysisResult = "عنوان URL غير صحيح" }
            return
        }
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["inlineData": [
                            "mimeType": "image/jpeg",
                            "data": imageData
                        ]],
                        ["text": """
                        ابدأ تحليل الرسم والرموز التي رسمها الطفل بطريقة سهلة الفهم ومن ناحية نفسية.
                        عمر الطفل: \(childAge).
                        الرجاء شرح العناصر الموجودة في الرسم وتفسيرها نفسيًا بطريقة مبسطة.
                        ابتعد عن استخدام العناوين بخط عريض (بلود) واعتمد على هذا الريسورس \(downloadedBooks)
                        """]
                    ]
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        isLoading = true
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async { isLoading = false }
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    sheetData.analysisResult = "خطأ في الاتصال: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    sheetData.analysisResult = "لم يتم استقبال بيانات من الخادم"
                }
                return
            }
            
            // طباعة الرد الخام لفحص محتوياته
            if let responseString = String(data: data, encoding: .utf8) {
                print("Raw Response: \(responseString)")
            }
            
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = jsonResponse["candidates"] as? [[String: Any]],
               let content = candidates.first?["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let text = parts.first?["text"] as? String {
                
                DispatchQueue.main.async {
                    sheetData.analysisResult = text
                    analysisCache[imageHash] = text
                }
            } else {
                DispatchQueue.main.async {
                    sheetData.analysisResult = "لم يتمكن النظام من تحليل الصورة"
                }
            }
        }.resume()
    }
}
struct AnalysisPage_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisPage().environmentObject(Model())
    }
}
    
