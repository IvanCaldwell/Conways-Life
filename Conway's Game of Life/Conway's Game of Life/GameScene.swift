//
//  GameScene.swift
//  Conway's Game of Life
//
//  Created by Ivan Caldwell on 7/18/19.
//  Copyright © 2019 Ivan Caldwell. All rights reserved.
//

import SpriteKit

let cellSize: CGFloat = 25
class GameScene: SKScene {
    
    var interval = 0
    var grid = [Cell]()
    var future = [Cell]()
    let emptyCell = Cell(position: .zero)
    var restartNode = SKNode()
    var generationLabel = SKLabelNode()
    var generationBackground = SKSpriteNode()
    var restartButton = SKSpriteNode()
    lazy var cellsPerRow = Int(view!.bounds.width / (cellSize))
    lazy var cellsPerColumn = Int(view!.bounds.height/(cellSize))
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // Creating Setup
        generationBackground = SKSpriteNode(color: SKColor.white,
                                            size: CGSize(width: self.frame.width * 1.1,
                                                         height: self.frame.height * 0.075))
        generationBackground.position = CGPoint(x: self.frame.width / 2,
                                                y: self.frame.height * 0.1)
        generationBackground.addChild(generationLabel)
        generationLabel.position = CGPoint(x: self.frame.width * 0.075, y: self.frame.height * 0.00025)
        generationLabel.fontSize = 40
        generationLabel.zPosition = 8
        generationLabel.fontColor = .black
        self.addChild(generationBackground)
        for y in 0..<cellsPerColumn{
            for x in 0..<cellsPerRow{
                let defaultCell = Cell(position: CGPoint(x: CGFloat(x) * (cellSize + 0.5), y: CGFloat(y) * (cellSize + 0.5)))
                let newCell = Cell(position: CGPoint(x: CGFloat(x) * (cellSize + 0.5), y: CGFloat(y) * (cellSize + 0.5)),
                                   // Creating the Oscillators
                    living: x == 8 && y == 25 || x == 6 && y == 25 || x == 7 && y == 25
                        // Creating the Toad
                        || x == 3 && y == 30  || x == 4 && y == 30  || x == 5 && y == 30 || x == 4 && y == 29 || x == 5 && y == 29 || x == 6 && y == 29
                        // Creating the Glider Space Ship
                        || x == 2 && y == 22 || x == 2 && y == 21 || x == 2 && y == 20 || x == 1 && y == 20 || x == 0 && y == 21
                )
                addChild(newCell)
                grid.append(newCell)
                future.append(defaultCell)
                createRestartButton()
            }
        }
        
        let generation = SKAction.run {
            self.generationLabel.text = "Generation: \(self.interval)"
            self.nextGeneration()
            self.copyGeneration()
            self.interval += 1
        }
        
        let wait = SKAction.wait(forDuration: 0.25)
        
        run(SKAction.repeatForever(SKAction.sequence([generation, wait])))
    }
    
    // TESTING For Edges
    func cellAt(x: Int, y: Int) -> Cell {
        if x < 0 || y < 0 || x >= cellsPerRow || y >= cellsPerColumn {
            return emptyCell
        }
        return grid[x + y * cellsPerRow]
    }
    
    func futureCellAt(x: Int, y: Int) -> Cell {
        if x < 0 || y < 0 || x >= cellsPerRow || y >= cellsPerColumn {
            return emptyCell
        }
        return future[x + y * cellsPerRow]
    }
    
    // TOUCH INPUT
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Check if restart button was tapped
        for touch in touches {
            let location =  touch.location(in: self)
            if restartButton.contains(location) {
                future = []
                grid = []
                for y in 0..<cellsPerColumn{
                    for x in 0..<cellsPerRow{
                        let defaultCell = Cell(position: CGPoint(x: CGFloat(x) * (cellSize + 0.5), y: CGFloat(y) * (cellSize + 0.5)))
                        let newCell = Cell(position: CGPoint(x: CGFloat(x) * (cellSize + 0.5), y: CGFloat(y) * (cellSize + 0.5)),
                                           // Creating the Oscillators
                            living: x == 8 && y == 25 || x == 6 && y == 25 || x == 7 && y == 25
                                // Creating the Toad
                                || x == 3 && y == 30  || x == 4 && y == 30  || x == 5 && y == 30 || x == 4 && y == 29 || x == 5 && y == 29 || x == 6 && y == 29
                                // Creating the Glider Space Ship
                                || x == 2 && y == 22 || x == 2 && y == 21 || x == 2 && y == 20 || x == 1 && y == 20 || x == 0 && y == 21
                        )
                        addChild(newCell)
                        grid.append(newCell)
                        future.append(defaultCell)
                        interval = 0
                    }
                    
                }
            }
        }
        
    }
    
    // CREATING RESTART BUTTON
    func createRestartButton() {
        let restartLabel = SKLabelNode()
        restartLabel.name = "restart"
        restartLabel.position = CGPoint(x: self.frame.width / 2,
                                        y: self.frame.height * 0.0125)
        restartLabel.text = "Restart"
        restartLabel.fontSize = 40
        restartLabel.zPosition = 8
        self.addChild(restartLabel)
        restartButton = SKSpriteNode(color: SKColor.black,
                                     size: CGSize(width: self.frame.width * 1.1,
                                                  height: self.frame.height * 0.125))
        restartButton.position = CGPoint(x: self.frame.width / 2,
                                         y: self.frame.height * 0.025)
        restartButton.zPosition = 7
        self.addChild(restartButton)
    }
    
    // CREATING GENERATION Label Todo
    func nextGeneration() {
        for y in 0..<cellsPerColumn {
            for x in 0..<cellsPerRow {
                let futureCell = futureCellAt(x: x, y: y)
                let currentCell = cellAt(x: x, y: y)
                let numOfNeighbors =  cellAt(x: x - 1, y: y - 1).getStatus() +
                    cellAt(x: x,     y: y - 1).getStatus() +
                    cellAt(x: x + 1, y: y - 1).getStatus() +
                    cellAt(x: x - 1, y: y).getStatus() +
                    cellAt(x: x + 1, y: y).getStatus() +
                    cellAt(x: x - 1, y: y + 1).getStatus() +
                    cellAt(x: x,     y: y + 1).getStatus() +
                    cellAt(x: x + 1, y: y + 1).getStatus()
                
                if currentCell.alive {
                    if numOfNeighbors < 2 || numOfNeighbors > 3 {
                        futureCell.alive = false
                    } else {
                        futureCell.alive = currentCell.alive
                    }
                } else if numOfNeighbors == 3 {
                    futureCell.alive = true
                }
            }
        }
    }
    
    func copyGeneration(){
        for y in 0..<cellsPerColumn {
            for x in 0..<cellsPerRow {
                let futureCell = futureCellAt(x: x, y: y)
                let currentCell = cellAt(x: x, y: y)
                currentCell.alive = futureCell.alive
            }
        }
    }
}
