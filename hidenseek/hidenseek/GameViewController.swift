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

//    ghost node
    var pyramidNode:SCNNode!


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
        scene.lightingEnvironment.intensity = -1.5
        
        sceneView.scene = scene
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    func setUpNodes(){
        spotLightNode = scene.rootNode.childNode(withName: "spotLight", recursively: true)
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
        pyramidNode = scene.rootNode.childNode(withName: "pyramid", recursively: true)

    }
    
    @objc func sceneViewTapped(recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node{
                print("\(node.parent?.name)")
                if node.parent?.name == "skin0"{
//                    write the code here
                    node.parent?.isHidden = true
                }
            }
        }
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
        
        spotLightNode.position = pov.position
        spotLightNode.orientation = pov.orientation
        spotLightNode.eulerAngles = pov.eulerAngles
        
        // Create a physics body for the spotlight.
        let spotlightPhysicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: SCNBox(width: 0.5, height: 0.5, length: 100, chamferRadius: 0), options: nil))
        
        spotlightPhysicsBody.contactTestBitMask = 2

        // Assign the physics body to the spotlight node.
        spotLightNode.physicsBody = spotlightPhysicsBody

        // Perform a physics-based contact test for the spotlight node.
        let contactResults = sceneView.scene?.physicsWorld.contactTest(with: spotLightNode.physicsBody!, options: nil)

        print(contactResults?.count)
        
        // Process the contact results.
        for contactResult in contactResults! {
            let nodeA = contactResult.nodeA
            let nodeB = contactResult.nodeB
            // Perform necessary checks or actions based on the contact results.
            print("node a \(nodeA.name)")
            print("node b \(nodeB.name)")
        }
        
        
    }
}




