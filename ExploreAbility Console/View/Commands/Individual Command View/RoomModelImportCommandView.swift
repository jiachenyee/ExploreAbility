//
//  RoomModelImportCommandView.swift
//  ExploreAbility Console
//
//  Created by Jia Chen Yee on 29/4/23.
//

import SwiftUI
import SceneKit
import RealityKit

struct RoomModelImportCommandView: View {
    
    @State var fileImporterPresented = false
    
    @State var isAlertPresented = false
    @State var alertText = ""
    
    @Binding var roomCaptureData: RoomCaptureData?
    
    var scene: SCNScene? {
        if let usdzURL = roomCaptureData?.usdzURL,
           let scene = try? SCNScene(url: usdzURL) {
            scene.background.contents = NSColor.gray
            return scene
        }
        return nil
    }
    
    var body: some View {
        CommandView(icon: {
            Image(systemName: "cube.transparent")
                .foregroundColor(.yellow)
        }, title: "Room 3D Model") {
            VStack(alignment: .leading) {
                HStack {
                    Text("Room Scan")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Spacer()
                    Button {
                        fileImporterPresented.toggle()
                    } label: {
                        Text(roomCaptureData == nil ? "Import" : "Change…") 
                    }

                }
                
                if let scene {
                    SceneView(scene: scene, options: [ .autoenablesDefaultLighting, .temporalAntialiasingEnabled, .allowsCameraControl])
                        .cornerRadius(8)
                } else {
                    Divider()
                        .padding(.vertical, 4)
                    
                    Text("Use the *ExploreAbility Room Scanner* tool to generate a JSON file.")
                        .multilineTextAlignment(.leading)
                }
            }
            .fileImporter(isPresented: $fileImporterPresented, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let url):
                    do {
                        let decoder = JSONDecoder()
                        let roomCaptureData = try decoder.decode(RoomCaptureImportedData.self, from: try Data(contentsOf: url))
                        
                        let fileURL = FileManager.default.temporaryDirectory.appending(path: "RoomCapture.usdz")
                        
                        try roomCaptureData.usdzData.write(to: fileURL)
                        
                        self.roomCaptureData = RoomCaptureData(walls: roomCaptureData.walls, usdzURL: fileURL)
                    } catch {
                        alertText = error.localizedDescription
                        isAlertPresented = true
                    }
                case .failure(let error):
                    alertText = error.localizedDescription
                    isAlertPresented = true
                }
            }
            .alert("Unable to Read Data", isPresented: $isAlertPresented) {
                Button("Done") {
                }
            } message: {
                Text("")
            }
        }
    }
}
