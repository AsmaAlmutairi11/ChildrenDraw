//
//  CameraView.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 09/09/1446 AH.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: View {
    @EnvironmentObject var cameraData: Model
    @StateObject var camera = CameraModel()
    @State private var showSheetInformation = false  // متغير للتحكم في ظهور الشيت

    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            
            if !camera.isTaken {
                Image("Rectangle1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 340, height: 411)
                    .transition(.scale)
            }
            
            VStack {
                if camera.isTaken {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                camera.reTake()
                            }
                        }, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing, 10)
                    }
                }
                
                Spacer()
                
                HStack {
                    if camera.isTaken {
                        Button(action: {
                            // إذا لم تكن الصورة محفوظة مسبقًا، نستدعي savePic
                            if !camera.isSaved {
                                camera.savePic(cameraData: cameraData)
                            }
                            
                            // تحويل بيانات الصورة إلى UIImage وتخزينها في cameraData
                            if let image = UIImage(data: camera.picData) {
                                cameraData.capturedImage = image
                            }
                            
                            // إظهار الشيت
                            showSheetInformation = true
                            
                        }, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                    

                        .padding(.leading)
                        
                        Spacer()
                    } else {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                camera.takePic()
                            }
                        }, label: {
                            ZStack {
                                Circle()
                                    .fill(Color.babyBlue)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.babyBlue, lineWidth: 2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                        .transition(.scale)
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            camera.Check()
        }
        .alert(isPresented: $camera.alert) {
            Alert(title: Text("Please Enable Camera Access"))
        }
        .sheet(isPresented: $showSheetInformation) {
            // تمرير النموذج المشترك للـ SheetInformation
            SheetInformation().environmentObject(cameraData)
        }
    }
}
