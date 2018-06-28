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
    
    private let highPriorityBackgroundQueue = DispatchQueue(label: "highPriorityBackgroundQueue", qos: .userInteractive)
    private var trackingImages = Set<ARReferenceImage>()
    private var snipits = [Snipit]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let persistanceManager = PersistanceManager()
        
        highPriorityBackgroundQueue.async {
            self.snipits = persistanceManager.fetchSnipits()
            
            let trackingImagesArray = self.snipits.compactMap { (snipit) -> ARReferenceImage? in
                if let image = UIImage(contentsOfFile: snipit.imagePath),
                    let cgImage = image.cgImage {
                    
                    let refImage =  ARReferenceImage(cgImage,
                                                     orientation: .up,
                                                     physicalWidth: CGFloat(snipit.width)) 
                    refImage.name = snipit.name
                    print("refImageName: " + refImage.name!)
                    
                    return refImage
                } else {
                    return nil
                }
            }
            
            self.trackingImages = Set(trackingImagesArray)
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.detectionImages = self.trackingImages
            configuration.maximumNumberOfTrackedImages = self.trackingImages.count
            
            DispatchQueue.main.async {
                self.sceneView.session.run(configuration)
            }
        }
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
        
        if let anchor = anchor as? ARImageAnchor,
            let anchorImageName = anchor.referenceImage.name,
            let snipit = snipits.first(where: { $0.name == anchorImageName } ) {
                return VideoNode(with: 1.0, height: 1.36, fileName: snipit.videoPath)
        }
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let vidNode = node as? VideoNode {
            vidNode.play()
        }
    }
}
