//
//  AnimationView.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 08/09/1446 AH.
//

import SwiftUI

struct AnimationView: View {
    @State private var offset: CGFloat = 10
    @State private var scale: CGFloat = 1.0
    
    let topOffset: CGFloat = -100
    let bottomOffset: CGFloat = 30
    let moveDuration: Double = 2
    let pauseDuration: Double = 1.5
    
    var body: some View {
        NavigationView {
            VStack {
                Image("yourImageName")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 400)
                    .scaleEffect(scale)
                    .offset(y: offset)
                    .onAppear {
                        animate()
                    }
                
                NavigationLink(destination:
                                CameraView())   {
                    Text("Next")
                        .font(.headline)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.top, 20)
            }
            .navigationTitle("Animation")
        }
    }
    
    func animate() {
        withAnimation(Animation.easeInOut(duration: moveDuration)) {
            offset = topOffset
            scale = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + moveDuration + pauseDuration) {
            withAnimation(Animation.easeInOut(duration: moveDuration)) {
                offset = bottomOffset
                scale = 0.7
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + moveDuration + pauseDuration) {
                animate()
            }
        }
    }
}



struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}
