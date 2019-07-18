//
//  Cell.swift
//  Conway's Game of Life
//
//  Created by Ivan Caldwell on 7/18/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import UIKit
import SpriteKit

class Cell: SKSpriteNode {
    var alive = false {
        didSet {
            if alive { color = .black }
            else { color = .white }
        }
    }
    
    init(position: CGPoint, living: Bool = false) {
        super.init(texture: nil, color: .white, size: CGSize(width: cellSize, height: cellSize))
        self.alive = living
        if living { color = .black }
        else { color = .white }
        self.position = position
        self.anchorPoint = .zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStatus() -> Int {
        return alive ? 1 : 0
    }
}

