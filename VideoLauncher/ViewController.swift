//
//  ViewController.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-25.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

import SpriteKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private var trackingImages = Set<ARReferenceImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene()
        
        if let images = ARReferenceImage.referenceImages(inGroupNamed: "TrackingImages", bundle: nil) {
            trackingImages = images
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = trackingImages

        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    @IBAction func sceneViewPinched(_ sender: UIPinchGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        if sender.state == .began || sender.state == .changed {
            let results = sceneView.hitTest(location, options: [.boundingBoxOnly: true])
            let result = results.filter { (result) -> Bool in
                return result.node is VideoNode
                }.map { (result) -> VideoNode in
                    return result.node as! VideoNode
                }.first
            
            guard let videoNode = result else { return }

            let scalex = Float(sender.scale) * videoNode.scale.x
            let scaley = Float(sender.scale) * videoNode.scale.y
            let scalez = Float(sender.scale) * videoNode.scale.z
            
            print("scalex: \(scalex) scaley: \(scaley) scalez: \(scalez)")
            print("videoNode scale: \(videoNode.scale)")
            
            result?.scale = SCNVector3(scalex, scaley, scalez)
            sender.scale = 1 
        }
        
    }
    
    @IBAction func sceneViewLongPress(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    @IBAction func sceneViewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: sceneView)
        
        let results = sceneView.hitTest(location, options: [.boundingBoxOnly : true])
        let videoNode = results.filter { (result) -> Bool in
            return result.node is VideoNode
            }.map { (result) -> VideoNode in
                return result.node as! VideoNode
            }.first
        
        if let videoNode = videoNode {
            if videoNode.isVideoPaused {
                videoNode.play()
            } else {
                videoNode.pause()
            }
        }
    }
    

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let _ = anchor as? ARImageAnchor {
            let vidNode = VideoNode(with: 2.0, height: 1.5, fileName: "will.mov")
            return vidNode
        }
     
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let vidNode = node as? VideoNode {
            vidNode.play()
        }
    }
}
