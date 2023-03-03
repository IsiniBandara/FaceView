//
//  FaceViewController.swift
//  FaceView
//
//  Created by Isini Bandara on 2023-03-04.
//


import UIKit
import ARKit

class FaceViewController: UIViewController, ARSCNViewDelegate {

    var detections: String = ""
    
    let message: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = .systemFont(ofSize: 24)
        lable.backgroundColor = .systemCyan
        return lable
    }()
    
    let arView: ARSCNView = {
        let arView = ARSCNView(frame: .zero)
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arView.session.run(ARFaceTrackingConfiguration())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(arView)
        self.arView.addSubview(message)
        
        arView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        arView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        message.heightAnchor.constraint(equalToConstant: 50).isActive = true
        message.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        message.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        message.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        arView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let mesh = ARSCNFaceGeometry(device: arView.device!, fillMesh: false)
        let node = SCNNode(geometry: mesh!)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeo = node.geometry as? ARSCNFaceGeometry {
            faceGeo.update(from: faceAnchor.geometry)
            expression(anchor: faceAnchor)
            DispatchQueue.main.async {
                self.message.text = self.detections
            }
        }
    }
    
    func expression(anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        
        self.detections = ""
        
        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            self.detections += "Your smile is awsome ❤️❤️"
        }
        
        let toung = anchor.blendShapes[.tongueOut]
        if toung?.decimalValue ?? 0.0 > 0.1 {
            self.detections += "Put Your Toung In 😂😂"
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
