//
//  viewPic.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 09/09/1446 AH.
//

import Foundation
import SwiftUI

struct viewPic: View {
    @EnvironmentObject var model: Model

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // عرض الصورة المُلتقطة
                    if let capturedImage = model.capturedImage {
                        Image(uiImage: capturedImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    } else {
                        Text("لا توجد صورة لعرضها")
                            .foregroundColor(.gray)
                    }
                    
                    // عرض اسم الصورة
                    HStack {
                        Text("اسم الصورة:")
                            .font(.headline)
                        Spacer()
                        Text(model.imageName)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    // عرض عمر الطفل المختار
                    HStack {
                        Text("عمر الطفل:")
                            .font(.headline)
                        Spacer()
                        Text(model.selectedAge)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    // يمكن عرض نتيجة التحليل إذا كانت موجودة
                    if !model.analysisResult.isEmpty {
                        HStack {
                            Text("نتيجة التحليل:")
                                .font(.headline)
                            Spacer()
                            Text(model.analysisResult)
                                .font(.subheadline)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("عرض الصورة")
        }
    }
}

struct viewPic_Previews: PreviewProvider {
    static var previews: some View {
        viewPic()
            .environmentObject(Model())
    }
}
