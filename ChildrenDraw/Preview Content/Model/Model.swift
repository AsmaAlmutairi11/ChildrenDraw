//
//  Model.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 09/09/1446 AH.
//

import SwiftUI
import Foundation
import CryptoKit

class Model: ObservableObject {
    @Published var capturedImage: UIImage? = nil
    @Published var imageName: String = ""
    @Published var selectedAge: String = ""
    @Published var analysisResult: String = ""
    @Published var childAge = ["3 سنوات", "4 سنوات", "5 سنوات", "6 سنوات"]
}
