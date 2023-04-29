/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller that manages the scanning process.
*/

import UIKit
import RoomPlan
import SceneKit
import simd

class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    
    @IBOutlet var exportButton: UIButton?
    
    @IBOutlet var doneButton: UIBarButtonItem?
    @IBOutlet var cancelButton: UIBarButtonItem?
    
    private var isScanning: Bool = false
    
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig: RoomCaptureSession.Configuration = RoomCaptureSession.Configuration()
    
    private var finalResults: CapturedRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up after loading the view.
        setupRoomCaptureView()
    }
    
    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        
        view.insertSubview(roomCaptureView, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }
    
    override func viewWillDisappear(_ flag: Bool) {
        super.viewWillDisappear(flag)
        stopSession()
    }
    
    private func startSession() {
        isScanning = true
        roomCaptureView?.captureSession.run(configuration: roomCaptureSessionConfig)
        
        setActiveNavBar()
    }
    
    private func stopSession() {
        isScanning = false
        roomCaptureView?.captureSession.stop()
        
        setCompleteNavBar()
    }
    
    // Decide to post-process and show the final results.
    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }
    
    // Access the final post-processed results.
    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
    }
    
    @IBAction func doneScanning(_ sender: UIBarButtonItem) {
        if isScanning { stopSession() } else { cancelScanning(sender) }
    }

    @IBAction func cancelScanning(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    // Export the USDZ output by specifying the `.parametric` export option.
    // Alternatively, `.mesh` exports a nonparametric file and `.all`
    // exports both in a single USDZ.
    @IBAction func exportResults(_ sender: UIButton) {
        let jsonEncoder = JSONEncoder()
        
        finalResults?.walls.forEach({ surface in
            surface.completedEdges.forEach { i in
                print(i)
            }
        })
        
        do {
            let usdzURL = FileManager.default.temporaryDirectory.appending(path: "Room.usdz")
            let tempRoomDataURL = FileManager.default.temporaryDirectory.appending(path: "RoomData.json")
            
            try finalResults?.export(to: usdzURL, exportOptions: .mesh)
            
            let data = try Data(contentsOf: usdzURL)
            
            let wallPositions = finalResults!.walls.map { wall in
                convertToSCNVectors(dimensions: wall.dimensions, transform: wall.transform)
            }.map { (bottom: SCNVector3, top: SCNVector3) in
                [
                    Position(x: Double(bottom.x), y: Double(bottom.z)),
                    Position(x: Double(top.x), y: Double(top.z))
                ]
            }
            
            try jsonEncoder.encode(RoomCaptureData(walls: wallPositions, usdzData: data)).write(to: tempRoomDataURL)
            
            let activityVC = UIActivityViewController(activityItems: [tempRoomDataURL], applicationActivities: nil)
            activityVC.modalPresentationStyle = .popover
            
            present(activityVC, animated: true, completion: nil)
            if let popOver = activityVC.popoverPresentationController {
                popOver.sourceView = self.exportButton
            }
        } catch {
            print("Error = \(error)")
        }
    }
    
    private func setActiveNavBar() {
        UIView.animate(withDuration: 1.0, animations: {
            self.cancelButton?.tintColor = .white
            self.doneButton?.tintColor = .white
            self.exportButton?.alpha = 0.0
        }, completion: { complete in
            self.exportButton?.isHidden = true
        })
    }
    
    private func setCompleteNavBar() {
        self.exportButton?.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.cancelButton?.tintColor = .systemBlue
            self.doneButton?.tintColor = .systemBlue
            self.exportButton?.alpha = 1.0
        }
    }
    
    func convertToSCNVectors(dimensions: simd_float3, transform: simd_float4x4) -> (bottom: SCNVector3, top: SCNVector3) {
        // Extract the scale components from the transform matrix
        let scale = simd_float3(
            length(transform.columns.0),
            length(transform.columns.1),
            length(transform.columns.2)
        )
        
        // Calculate the half extents of the plane based on the dimensions
        let halfExtents = dimensions / 2
        
        // Calculate the local coordinate system vectors of the plane
        
        let right = simd_normalize(simd_make_float3(transform.columns.0) * scale.x)
        let up = simd_normalize(simd_make_float3(transform.columns.1) * scale.y)
        let forward = simd_normalize(simd_make_float3(transform.columns.2) * scale.z)
        
        // Calculate the bottom and top corners of the plane
        let bottomCorner = simd_make_float3(
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        ) - right * halfExtents.x - up * halfExtents.y - forward * halfExtents.z
        
        let topCorner = simd_make_float3(
            transform.columns.3.x,
            transform.columns.3.y,
            transform.columns.3.z
        ) + right * halfExtents.x + up * halfExtents.y + forward * halfExtents.z
        
        // Convert the simd_float3 values to SCNVector3
        let bottomCornerVector = SCNVector3(bottomCorner.x, bottomCorner.y, bottomCorner.z)
        let topCornerVector = SCNVector3(topCorner.x, topCorner.y, topCorner.z)
        
        return (bottomCornerVector, topCornerVector)
    }
}
