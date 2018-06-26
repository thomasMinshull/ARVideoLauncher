//
//  VideoNode.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-25.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit

class VideoNode: SCNNode {
    var spriteKitScene: SKScene!
    var videoSpriteKitNode: SKVideoNode!
    
    init(with width: CGFloat, height: CGFloat, fileName: String, rotation: Float = 0.0) {
        super.init()

        guard let urlString = Bundle.main.path(forResource: "will", ofType: "mov") else {
            fatalError("Can't construct url for file")
        }
        
        let url = URL(fileURLWithPath: urlString)
        videoSpriteKitNode = SKVideoNode(url: url)
        
        spriteKitScene = SKScene(size: CGSize(width: 640, height: 480))
        
        spriteKitScene.addChild(videoSpriteKitNode)
        
        videoSpriteKitNode.position = CGPoint(x: spriteKitScene.size.width/2, y: spriteKitScene.size.height/2)
        videoSpriteKitNode.zRotation = CGFloat(Float.pi/2 + rotation)
        videoSpriteKitNode.size = spriteKitScene.size
        
        let tvBox = SCNBox(width: width, height: 0.01, length: height, chamferRadius: 0.0)
        tvBox.firstMaterial?.diffuse.contents = spriteKitScene
        tvBox.firstMaterial?.isDoubleSided = true
        
        self.geometry = tvBox
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented for VideoNode")
    }
    
    func play() {
        videoSpriteKitNode?.play()
    }
    
    func pause() {
        videoSpriteKitNode?.pause()
    }
    
    func isPaused() -> Bool {
        return videoSpriteKitNode?.isPaused ?? false
    }
}
