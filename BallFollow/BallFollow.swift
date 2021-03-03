//  BallFollow.swift
//  BallFollow - Created by Issam Abushaban on 3/1/21.
//  My First ScreenSaver!

import ScreenSaver

class BallFollow: ScreenSaverView {

    // MARK: - Variables -----------------------------------------------------------
    private var lastBallPosition: CGPoint  = .zero
    private var currBallPosition: CGPoint  = .zero
    private var currBallDisplace: CGPoint  = .zero
    private var currBallVelocity: CGVector = .zero
    
    private let ballSize = NSSize(width: 25, height: 25)
    
    // MARK: - Initialization ------------------------------------------------------
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        lastBallPosition = initialPosition()
        currBallPosition = initialPosition()
        
        currBallDisplace = CGPoint(x: currBallPosition.x - lastBallPosition.x,
                                    y: currBallPosition.y - lastBallPosition.y)
        
        currBallVelocity = initialVelocity()
    }
    
    private func initialPosition() -> CGPoint {
        let xInit = CGFloat.random(in: 0...frame.width)
        let yInit = CGFloat.random(in: 0...frame.height)
        return CGPoint(x: xInit,y: yInit)
    }
    
    private func initialVelocity() -> CGVector {
        let xVelocity = CGFloat.random(in: 10...60)
        let yVelocity = CGFloat.random(in: 10...60)
        let xSign: CGFloat = Bool.random() ? 1 : -1
        let ySign: CGFloat = Bool.random() ? 1 : -1
        return CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign)
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -----------------------------------------------------------
    // This function will draw up a single frame
    override func draw(_ rect: NSRect) {
        drawBackground(.black)
        drawBall()
    }

    // This function will update the "state" of the screensaver
    override func animateOneFrame() {
        super.animateOneFrame()
        
        let oobAxes = checkOutOfBounds()
        if oobAxes.xAxis {
            currBallVelocity.dx *= -1
        }
        if oobAxes.yAxis {
            currBallVelocity.dy *= -1
        }

        currBallPosition.x += currBallVelocity.dx
        currBallPosition.y += currBallVelocity.dy
        
        // This is for the OS to know that we wish to redraw the screen
        setNeedsDisplay(bounds)
    }
    
    // MARK: - General Helpers -----------------------------------------------------
    
    private func checkOutOfBounds() -> (xAxis: Bool, yAxis: Bool) {
        let xAxisOOB = currBallPosition.x - ballSize.width <= 0 ||
            currBallPosition.x + ballSize.width >= bounds.width
        let yAxisOOB = currBallPosition.y - ballSize.height <= 0 ||
            currBallPosition.y + ballSize.height >= bounds.height
        return (xAxisOOB, yAxisOOB)
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }

    private func drawBall() {
        
        let ballRect = NSRect(x: currBallPosition.x - 25,
                              y: currBallPosition.y - 25,
                              width: 50,
                              height: 50)
        let ball = NSBezierPath(roundedRect: ballRect,
                                xRadius: 25,
                                yRadius: 25)
        NSColor.white.setFill()
        ball.fill()
    }
}
