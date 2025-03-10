//
//  CustomSegmentedControl.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 08/09/1446 AH.
//

import Foundation
import SwiftUI

struct CustomSegmentedControl: View {
    let childAge: [String]         // مصفوفة الأعمار
    @Binding var selectedAge: Int  // المؤشر الحالي لعمر الطفل

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width / CGFloat(childAge.count)
            
            ZStack(alignment: .leading) {
                // الخلفية الثابتة للمكون
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white)
                
                // مؤشر التحديد ذو الحواف الدائرية
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.babyBlue)
                    .frame(width: 85, height: 33)
                    .offset(x: width * CGFloat(selectedAge))
                    .animation(.easeInOut(duration: 0.3), value: selectedAge)
                
                HStack(spacing: 0) {
                    // استخدم childAge بدلاً من options
                    ForEach(0..<childAge.count, id: \.self) { index in
                        Text(childAge[index])
                            // استخدم selectedAge بدلاً من selectedIndex
                            .foregroundColor(selectedAge == index ? .white : .black)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedAge = index
                            }
                    }
                }
            }
        }
        .frame(height: 40)
    }
}
