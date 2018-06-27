//
//  ARImageTesterViewController.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-26.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

protocol ImageTesterDelegate {
    func ARImageTesterViewController(_ imageTesterViewController: ARImageTesterViewController, didVerify image: UIImage)
}

class ARImageTesterViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var uiViews: [UIView]!
    var image: UIImage!
    var delegate: ImageTesterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIViews()

        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let referenceImage = ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 1.0)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = [referenceImage]
        configuration.maximumNumberOfTrackedImages = 1
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - Helper functions
    
    private func configureUIViews() {
        for view in uiViews {
            view.layer.cornerRadius = 5.0
            view.backgroundColor = UIColor.lightGray
            view.alpha = 0.5
        }
    }
    
    private func presentImageDetectedAlert() {
        let alert = UIAlertController(title: "Image Detected", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.delegate?.ARImageTesterViewController(self, didVerify: self.image)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true) 
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let _ = anchor as? ARImageAnchor {
            presentImageDetectedAlert()
        }
        
        return node
    }

}
