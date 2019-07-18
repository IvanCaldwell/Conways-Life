//
//  GameViewController.swift
//  Conway's Game of Life
//
//  Created by Ivan Caldwell on 7/18/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import SpriteKit


protocol LayoutSubviewDelegate: class {
    func safeAreaUpdated()
}


class GameViewController: UIViewController {
    weak var layoutSubviewDelegate:LayoutSubviewDelegate?
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let _ = self.view {
            layoutSubviewDelegate?.safeAreaUpdated()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Size our scene to fit the view exactly
            //let scene = GameScene(size: view.bounds.size)
            let scene = GameScene(size: UIScreen.main.bounds.size)
            //let scene = GameScene(size: CGSize(width: view.bounds.width * 0.75, height: view.bounds.height * 0.75))
            //let scene = GameScene(size: CGSize(width: 100, height: 200))
            scene.anchorPoint = CGPoint(x: 0.0, y: 0.05)
            // Set the scale mode
            scene.scaleMode = .aspectFill
            //scene.scaleMode = .aspectFit
            // Show the new scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
            //view.showsNodeCount = true
            view.showsPhysics = true
            
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
