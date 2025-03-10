//
//  ChildrenDrawApp.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 08/09/1446 AH.
//

import SwiftUI

@main
struct YourAppName: App {
    @StateObject var MainData = Model()

    var body: some Scene {
        WindowGroup {
            AnimationView()
                .environmentObject(MainData)
        }
    }
}
