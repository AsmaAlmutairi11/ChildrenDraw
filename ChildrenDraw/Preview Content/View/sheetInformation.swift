//
//  sheetInformation.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 08/09/1446 AH.
import Foundation
import SwiftUI

import SwiftUI

struct SheetInformation: View {
    @EnvironmentObject var sheetData: Model
    @State private var selectedAge: Int = 0
    @State private var imageName: String = ""
    @State private var navigateToAnalysis: Bool = false
    var childAge = ["3 سنوات", "4 سنوات", "5 سنوات", "6 سنوات"]

    private var sheetBackground: some View {
        Color("sheetBackground")
            .ignoresSafeArea()
    }

    var body: some View {
        NavigationView {
            ZStack {
                sheetBackground

                VStack(alignment: .trailing, spacing: 20) {
                    Text("إختر عمر الطفل :")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    CustomSegmentedControl(
                        childAge: childAge,
                        selectedAge: $selectedAge
                    )
                    .frame(maxWidth: .infinity, alignment: .trailing)

                    Text("اسم الصورة:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    HStack {
                        TextField("أدخل اسم الصورة", text: $imageName)
                            .padding(12)
                            .background(Color.white)
                            .cornerRadius(25)
                            .multilineTextAlignment(.trailing)
                        
                        if !imageName.isEmpty {
                            Button(action: { imageName = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                    
                    // NavigationLink مخفي للتحويل إلى صفحة التحليل.
                    NavigationLink(
                        destination: AnalysisPage().environmentObject(sheetData),
                        isActive: $navigateToAnalysis,
                        label: { EmptyView() }
                    )

                    Button(action: {
                        // تحديث بيانات النموذج المشترك
                        sheetData.imageName = imageName
                        sheetData.selectedAge = childAge[selectedAge]
                        // الانتقال لصفحة التحليل
                        navigateToAnalysis = true
                    }) {
                        Text("حل الصورة")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orangeCustom)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
            .navigationTitle("المعلومات")
            .navigationBarTitleDisplayMode(.inline)
        }
        .interactiveDismissDisabled(false)
    }
}
