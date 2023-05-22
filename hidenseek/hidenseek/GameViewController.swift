//
//  GameViewController.swift
//  hidenseek
//
//  Created by Jeremy Christopher on 22/05/23.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView:SCNView!
    var scene:SCNScene!
    
//    camera node
    var cameraNode:SCNNode!
    
//    spotlight node
    var spotLightNode:SCNNode!
    
//    character node
    var modelNode:SCNNode!



    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()
        setUpNodes()
//        updateSpotlightPosition()
        sceneView.delegate = self

    }
    
    func setUpScene(){
        sceneView = self.view as! SCNView
        
        sceneView.allowsCameraControl = true

        scene = SCNScene(named: "art.scnassets/mainScene.scn")
        scene.lightingEnvironment.intensity = -0.1
        sceneView.scene = scene
    }
    
    func setUpNodes(){
        spotLightNode = scene.rootNode.childNode(withName: "spotLight", recursively: true)
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
//        modelNode = scene.rootNode.childNode(withName: "character", recursively: true)
        
//        let desiredWidth: Float = 2.0
//        let desiredHeight: Float = 1.5
//        let desiredDepth: Float = 3.0

//        modelNode.scale = SCNVector3(desiredWidth, desiredHeight, desiredDepth)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    // Implement the renderer(_:updateAtTime:) method here
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let pov = sceneView.pointOfView else {
            return
        }

//         Update the position and direction of the spotlight node
        spotLightNode.position = pov.position
        spotLightNode.orientation = pov.orientation
        print("CameraNode \(pov.position)")
        print("Spotlight \(spotLightNode.position)")
        print("Spotlight Orien \(spotLightNode.orientation)")
    }
}

