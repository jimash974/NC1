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
    var ghost:SCNNode!
    
    //    ray node
        var ray:SCNNode!
    
    //    ray2 node
        var ray2:SCNNode!
    
    var score:Int = 0
    
    var ghostScary: SCNNode!
    
    var sounds:[String:SCNAudioSource] = [:]


    
    private var scoreLabel: UILabel!
    private var lifeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScene()
        setUpNodes()
        setupSounds()
//        updateSpotlightPosition()
        sceneView.delegate = self
//        scene.physicsWorld.contactDelegate = self


        

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
        
        scene.physicsWorld.contactDelegate = self
        
        sceneView.debugOptions = [.showPhysicsShapes]
        
        // Create the score label
        scoreLabel = UILabel(frame: CGRect(x: view.bounds.width - 100, y: 20, width: 80, height: 30))
//        scoreLabel.textAlignment =
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(scoreLabel)
        
        // Add constraints to position the score label in the top left corner
          let constraints = [
              scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
              scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
          ]
          NSLayoutConstraint.activate(constraints)

//        lifeLabel = UILabel(frame: CGRect(x: view.bounds.width - 100, y: 20, width: 80, height: 30))
//        lifeLabel.textAlignment = .left
//        lifeLabel.textColor = UIColor.white
//        lifeLabel.font = UIFont.systemFont(ofSize: 18)
//        view.addSubview(lifeLabel)
//
//
//        lifeLabel.text = "Your life : \(life)"
        scoreLabel.text = "\(score)/10"


    }
    
    func setUpNodes(){
        spotLightNode = scene.rootNode.childNode(withName: "spotLight", recursively: true)
        cameraNode = scene.rootNode.childNode(withName: "camera", recursively: true)
        ghost = scene.rootNode.childNode(withName: "ghost reference", recursively: true)
        ghostScary = scene.rootNode.childNode(withName: "ghost reference", recursively: true)
        ghostScary.isHidden = true
    }
    
    func setupSounds() {
//        let sawSound = SCNAudioSource(fileNamed: "chainsaw.wav")!
        let jumpSound = SCNAudioSource(fileNamed: "jump.wav")!
//        sawSound.load()
        jumpSound.load()
//        sawSound.volume = 0.3
        jumpSound.volume = 0.4
        
//        sounds["saw"] = sawSound
        sounds["jump"] = jumpSound
        
//        let backgroundMusic = SCNAudioSource(fileNamed: "background.mp3")!
//        backgroundMusic.volume = 0.1
//        backgroundMusic.loops = true
//        backgroundMusic.load()
        
//        let musicPlayer = SCNAudioPlayer(source: backgroundMusic)
//        ballNode.addAudioPlayer(musicPlayer)
    }
    
    @objc func sceneViewTapped(recognizer:UITapGestureRecognizer){
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults.first
            if let node = result?.node{
                print("\(node.parent?.name)")
//                print("Ghost \(ghost.parent?.position)")
                print("Ghost name \(ghost?.name)")
                print("Physicsc \(ghost?.physicsBody)")

                
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
        if(nodeA.name == "ghost reference" || nodeB.name == "ghost reference"){
//

            

                print("in")
            if nodeA.name == "ghost reference"{
                ghostNode = nodeA.parent
                }else{
                    ghostNode = nodeB.parent
                }
            ghostScary.isHidden = true
            print("Ghost \(ghostNode?.name)")
            
//            print("Spotlight \(spotLightNode.position)")
//            print("Ghost \(ghostNode?.position)")
//            print("Name \(ghostNode?.name)")

            let waitAction = SCNAction.wait(duration: 5)
            
            if(ghostNode?.position.z == 4){
                let unhideAction = SCNAction.run { (node) in
                    node.isHidden = false
                }
                let hidePhysicsc = SCNAction.run { node in
                    node.childNodes[0].categoryBitMask = 1
                }
                
                let showPhysicsc = SCNAction.run { node in
                    node.childNodes[0].categoryBitMask = 2
                }
                
                print("ghost node \(ghostNode?.childNodes[0].name)")
                print("Physicsc \(ghostNode?.childNodes[0].physicsBody)")
                
                let waitActionn  = SCNAction.wait(duration: 2)
                print("jump sound \(sounds["jump"])")
                let sawSound = sounds["jump"]!
                ghostNode?.runAction(SCNAction.playAudio(sawSound, waitForCompletion: false))
                
                let hideAction = SCNAction.run { (node) in
                    node.isHidden = true
                }
                let ghostScaryAction = SCNAction.sequence([unhideAction, waitActionn, hideAction])
                
                let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: (ghostNode?.position.z)! * -1), duration: 0)
                let action = SCNAction.sequence([hidePhysicsc,moveAction, waitAction, showPhysicsc])
                ghostNode?.runAction(action)
                ghostScary.runAction(ghostScaryAction)
//                print("Ghost hidden \(ghostScary.isHidden)")
                
                

            }else if ghostNode?.position.z == -4{
                let moveAction = SCNAction.move(to: SCNVector3(x: -3, y: 0, z: 0), duration: 0)
                let action = SCNAction.sequence([waitAction,moveAction])
                ghostNode?.runAction(action)

            }else if ghostNode?.position.x == -3{
                let moveAction = SCNAction.move(to: SCNVector3(x: 5, y: 0, z: 0), duration: 0)
                let action = SCNAction.sequence([waitAction,moveAction])
                ghostNode?.runAction(action)

            }else if ghostNode?.position.x == 5{
                let moveAction = SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 4), duration: 0)
                let action = SCNAction.sequence([waitAction,moveAction])
                ghostNode?.runAction(action)
            }

//            let sequenceAction = SCNAction.sequence([moveAction, SCNAction.removeFromParentNode()])
//                    ghostNode?.runAction(sequenceAction)
            
                }
        }
    
//    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
//        var ghostNode:SCNNode?
//
//        let nodeA = contact.nodeA
//        let nodeB = contact.nodeB
//
//        if(nodeA.name != "ghost" || nodeB.name != "ghost"){
//         ghostNode = nil
//        }
//    }
    
}




