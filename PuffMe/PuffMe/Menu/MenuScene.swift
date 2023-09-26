//
//  MenuScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    override func didMove(to view: SKView) {
        let startButton = SKSpriteNode(color: .blue, size: CGSize(width: 300, height: 100))
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        startButton.size = CGSize(width: 200, height: 100)
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
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "startButton" {
                let scene = GameScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
}
