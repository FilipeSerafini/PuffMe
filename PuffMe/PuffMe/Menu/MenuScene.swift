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
        let scene = GameScene(size: CGSize(width: size.width, height: size.height))
        scene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
