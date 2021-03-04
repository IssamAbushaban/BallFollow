//
//  Ball.swift
//  BallFollow Ball Class
//
//  Created by Issam Abushaban on 3/2/21.
//

import CoreGraphics

/// The `Ball` class with a position, velocity and size.
public struct Ball {
    public var position: CGPoint = .zero
    public var velocity: CGVector = .zero

    //Default Constructor
    init()  {
    }
    
    //Specific Constructor
    init(position: CGPoint, velocity: CGVector) {
        self.position = position
        self.velocity = velocity
    }

}
