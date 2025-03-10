//
//  CameraModel.swift
//  ChildrenDraw
//
//  Created by Asma Mohammed on 09/09/1446 AH.
//

import Foundation
import SwiftUI
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.alert.toggle()
            }
        default:
            break
        }
    }
    
    func setUp() {
        do {
            self.session.beginConfiguration()
            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
            let input = try AVCaptureDeviceInput(device: device)
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            self.session.commitConfiguration()
        } catch {
            print("Setup Error: \(error.localizedDescription)")
        }
    }
    
    func takePic() {
        // التقاط الصورة
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        
        // إيقاف الجلسة في خيط خلفي
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            // تحديث حالة التقاط الصورة على main thread
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
            }
        }
    }
    
    func reTake() {
        // بدء الجلسة في خيط خلفي
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle() }
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Photo Processing Error: \(error.localizedDescription)")
            return
        }
        guard let imageData = photo.fileDataRepresentation() else { return }
        // تحديث بيانات الصورة على main thread
        DispatchQueue.main.async {
            self.picData = imageData
        }
    }
    
    func savePic(cameraData: Model) {
        DispatchQueue.main.async {
            // إذا كانت بيانات الصورة صالحة، نحولها إلى UIImage
            if let image = UIImage(data: self.picData) {
                cameraData.capturedImage = image
            }
            // تحديث حالة الحفظ
            self.isSaved = true
            print("Sheet will be shown.")
        }
    }


}
