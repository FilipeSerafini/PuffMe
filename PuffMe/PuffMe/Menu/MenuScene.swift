//
//  MenuScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    //tutorial variables
    var tutorial = UserDefaults.standard.value(forKey: "tutorial") as? Bool ?? false

    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
        
        let startButton = SKLabelNode(text: "Start Game")
        startButton.fontSize = 48
        startButton.fontName = "SFProRounded-Bold"
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        startButton.name = "startButton" // Set a name for identifying the node later
        addChild(startButton)

        // Create a Title Label
        let titleLabel = SKSpriteNode(imageNamed: "Title")
        titleLabel.size = CGSize(width: 300, height: 150)
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(titleLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //touch puff
            if let node = self.atPoint(location) as? SKLabelNode, node.name == "startButton" {
                vibrate(intensity: .medium)
                if(!tutorial) {
                    let tutorial = TutorialScene(size: CGSize(width: size.width, height: size.height))
                    tutorial.scaleMode = .aspectFill
                    
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(tutorial, transition: transition)
                    
                    UserDefaults.standard.setValue(true, forKey: "tutorial")
                }
                else {
                    let scene = GameScene(size: CGSize(width: size.width, height: size.height))
                    scene.scaleMode = .aspectFill
                    
                    let transition = SKTransition.fade(withDuration: 1.0)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
