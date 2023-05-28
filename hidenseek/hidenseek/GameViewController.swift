//
//  GameViewController.swift
//  hidenseek
//
//  Created by Jeremy Christopher on 22/05/23.
//

import UIKit
import SceneKit
import SpriteKit

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
    var ghost:SCNNode!
    
//    var score:Int = 0
    
    var ghostScary: SCNNode!
    
    var sounds:[String:SCNAudioSource] = [:]
    
    var health:Int = 3
    
//    private var scoreLabel: UILabel!
    var lifeLabel: UILabel!
    var healthLabel: SKLabelNode!

    
    var scoreLabel = SKLabelNode(text: "Score: 0")
    var score = 0
    
    var endText: SCNNode!

    var isFirstCollision = true
    
    var playAgainButton: UIButton!



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        setUpScene()
        setUpNodes()
        setupSounds()
        sceneView.delegate = self
//        scene.physicsWorld.contactDelegate = self
        setUpLabel()
        addButton()
        
        for gestureRecognizer in sceneView.gestureRecognizers ?? [] {
            if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
               tapGestureRecognizer.numberOfTapsRequired == 2 {
                sceneView.removeGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    

    func setUpLabel(){
        // Create a SpriteKit overlay for UI elements
        let overlayScene = SKScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene = overlayScene

        // Create a score label
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = UIColor.white
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.position = CGPoint(x: 17, y: sceneView.bounds.height - 10)
        overlayScene.addChild(scoreLabel)
        scoreLabel.text = "Score: \(score)/10"
        
        // Create the health label
        healthLabel = SKLabelNode(text: "Health: \(health)")
        healthLabel.fontSize = 24
        healthLabel.fontColor = UIColor.white
        healthLabel.horizontalAlignmentMode = .right
        healthLabel.verticalAlignmentMode = .top
        healthLabel.position = CGPoint(x: sceneView.bounds.width - 20, y: sceneView.bounds.height - 10)
        overlayScene.addChild(healthLabel)
    }
    
    func setUpScene(){
        sceneView = self.view as! SCNView
        
        sceneView.allowsCameraControl = true
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.6

        scene = SCNScene(named: "art.scnassets/mainScene.scn")
        scene.lightingEnvironment.intensity = -2.5
        
        sceneView.scene = scene
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        tapRecognizer.addTarget(self, action: #selector(GameViewController.sceneViewTapped(recognizer:)))
        sceneView.addGestureRecognizer(tapRecognizer)
        
        scene.physicsWorld.contactDelegate = self
//        sceneView.debugOptions = [.showPhysicsShapes]
    }
    
    func setUpNodes(){
        spotLightNode = scene.rootNode.childNode(withName: "spotLight", recursively: true)
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
        ghost = scene.rootNode.childNode(withName: "ghost reference", recursively: true)
        ghostScary = scene.rootNode.childNode(withName: "ghostScary reference", recursively: true)
        ghostScary.isHidden = true
        endText = scene.rootNode.childNode(withName: "endText", recursively: true)
        endText.isHidden = true
        
    }
    
    func setupSounds() {
//        let sawSound = SCNAudioSource(fileNamed: "chainsaw.wav")!
        let screamSound = SCNAudioSource(fileNamed: "scream.mp3")!
        screamSound.volume = 20.5

        screamSound.load()
        
        sounds["scream"] = screamSound
        
        let backgroundMusic = SCNAudioSource(fileNamed: "BackgroundMusic.wav")!
        backgroundMusic.volume = 1.5
        backgroundMusic.loops = true
        backgroundMusic.load()

        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
        scene.rootNode.addAudioPlayer(musicPlayer)
    }
    
    @objc func sceneViewTapped(recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node{
//                print("\(node.parent?.name)")
//                print("Ghost name \(ghost.parent?.name)")
                print("Ghost \(ghost.parent?.position)")
                print("Score : \(score)")

//                print("Physicsc \(ghost?.physicsBody)")

                if node.parent?.name == "skin0"{
//                    write the code here
                    print("Score \(score)")
                    node.parent?.isHidden = true
                    score += 1
                    scoreLabel.text = "\(score)/10"
                }
            }
        }
    }
    
    func addButton(){
        playAgainButton = UIButton(type: .system)
        playAgainButton.setTitle("Back to Home", for: .normal)
        playAgainButton.setTitleColor(.white, for: .normal)
        playAgainButton.backgroundColor = UIColor.gray
        playAgainButton.layer.opacity = 0.8
        playAgainButton.addTarget(self, action: #selector(playAgainButtonPressed), for: .touchUpInside)
        playAgainButton.frame = CGRect(x: 730, y: 50, width: 100, height: 40)
        self.view.addSubview(playAgainButton)
    }
    
    @objc func playAgainButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
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
        
        
        if score == 10 {
            // Create a 3D text geometry
            let textGeometry = SCNText(string: "You Win", extrusionDepth: 1.0)

            // Customize the text geometry properties as desired
            textGeometry.font = UIFont.systemFont(ofSize: 0.5) // Adjust the font and size
            textGeometry.flatness = 0.1 // Adjust the flatness
            textGeometry.firstMaterial?.diffuse.contents = UIColor.white // Adjust the color

            // Create a node using the text geometry
            let textNode = SCNNode(geometry: textGeometry)

            // Set the position of the text node
            textNode.position = SCNVector3(x: -1.053, y: -1.2, z: -6)
            spotLightNode.addChildNode(textNode)
        
            ghost.physicsBody = .none
        }
        
        if health <= 0 {
//            print("win")
            
            // Create a 3D text geometry
            let textGeometry = SCNText(string: "You Lose", extrusionDepth: 1.0)

            // Customize the text geometry properties as desired
            textGeometry.font = UIFont.systemFont(ofSize: 0.5) // Adjust the font and size
            textGeometry.flatness = 0.1 // Adjust the flatness
            textGeometry.firstMaterial?.diffuse.contents = UIColor.white // Adjust the color

            // Create a node using the text geometry
            let textNode = SCNNode(geometry: textGeometry)

            // Set the position of the text node
            textNode.position = SCNVector3(x: -1.053, y: -1.2, z: -6)
            spotLightNode.addChildNode(textNode)
            
            ghost.physicsBody = .none
        }
    }
    
    

    
}

extension GameViewController : SCNPhysicsContactDelegate {
//    func physicsWorld(_ world: SCNPhysicsWorld, didUpdate contact: SCNPhysicsContact) {
//        print("terst")
//    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        var ghostNode:SCNNode?
        print("MASUK ANJIR")

//        print("collision happen")
        // Process the contact results.
//        for contactResult in contact {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
            // Perform necessary checks or actions based on the contact results.
//            print("node a \(nodeA.name)")
//            print("node b \(nodeB.name)")
        

            
//        if(nodeA.childNodes[0].name == "ghost" || nodeB.name == "ghost"){
        if((nodeA.name == "ghost reference" || nodeB.name == "ghost reference") && isFirstCollision){
            print("in")
            if nodeA.name == "ghost reference"{
                ghostNode = nodeA.parent
                }else{
                    ghostNode = nodeB.parent
                }
            ghostScary.isHidden = true
//            print("Ghost \(ghostNode?.name)")
            
//            print("Spotlight \(spotLightNode.position)")
//            print("Ghost \(ghostNode?.position)")
//            print("Name \(ghostNode?.name)")

            var x:Float = 0
            var z:Float = 0
            
            if(ghostNode?.position.z == 4){
                z = -4

            }else if ghostNode?.position.z == -4{
                x = 5


            }else if ghostNode?.position.x == 5{
//                let moveAction = SCNAction.move(to: SCNVector3(x: 5, y: 0, z: 0), duration: 0)
//                let action = SCNAction.sequence([waitAction,moveAction])
//                ghostNode?.runAction(action)
                x = -3

            }else if ghostNode?.position.x == -3{
                z = 4
//                let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 4), duration: 0)
//                let action = SCNAction.sequence([waitAction,moveAction])
//                ghostNode?.runAction(action)
            }
            
            let changeCatMask = SCNAction.run { node in
                node.categoryBitMask = 0
            }
            let changeBackCatMask = SCNAction.run { node in
                node.categoryBitMask = 2
            }
            let moveAction = SCNAction.move(to: SCNVector3(x: x, y: 0, z: z), duration: 0)
            let action = SCNAction.sequence([changeCatMask,moveAction,changeBackCatMask])
            ghostNode?.runAction(action)

            let unhideAction = SCNAction.run { (node) in
                node.isHidden = false
            }
            
            let sawSound = sounds["scream"]!
            sceneView.scene?.rootNode.runAction(SCNAction.playAudio(sawSound, waitForCompletion: false))
            
            let hideAction = SCNAction.run { (node) in
                node.isHidden = true
            }
            
            let waitAction = SCNAction.wait(duration: 2)

            let ghostScaryAction = SCNAction.sequence([unhideAction, waitAction, hideAction])
            ghostScary.runAction(ghostScaryAction)
            
            print("collide position \(ghostNode?.position)")
            
            if(health > 0){
                health -= 1
            }
            
            print("health \(health)")
            healthLabel.text = "Health: \(health)"
            
            isFirstCollision = false
        }
    }
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        // Contact has ended
        isFirstCollision = true
    }
}




