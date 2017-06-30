//
//  Emitter.swift
//  Watercolors
//
//  Created by Paul ReFalo on 6/24/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit


class Emitter {
    
    class func get(image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterCells = generateEmitterCells(with: image)
        
        return emitter
    }
    
    class func generateEmitterCells(with image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.alphaRange = 0.5
        cell.birthRate = 0.8
        cell.lifetime = 50                                  // time in seconds
        cell.velocity = CGFloat(25)
        cell.emissionLongitude = (180 * (.pi / 180))        // Radians
        cell.emissionRange = (45 * (.pi / 180))             // Radians
        cell.scale = 0.4                                    // Percent of size
        cell.scaleRange = 1.0
        cells.append(cell)
        
        return cells
    }
}
