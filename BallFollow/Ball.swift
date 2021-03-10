//
//  Ball.swift
//  BallFollow Ball Class
//
//  Created by Issam Abushaban on 3/2/21.
//

import AppKit

/// The `Ball` class with a position, velocity and size.
public struct Ball {
    public  var position: CGPoint  = .zero
    public  var velocity: CGVector = .zero
    public  var color:    NSColor  = .white
    public  var radius:   CGFloat  = 15
    //Default Constructor
    init(_ color: NSColor,radius: CGFloat)  {
        self.color = color
        self.radius = abs(radius + 1)
    }
    
    //Specific Constructor
    init(position: CGPoint, velocity: CGVector) {
        self.position = position
        self.velocity = velocity
    }

}
