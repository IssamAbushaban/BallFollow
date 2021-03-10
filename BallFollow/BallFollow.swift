//  BallFollow.swift
//  BallFollow - Created by Issam Abushaban on 3/1/21.
//  My First ScreenSaver!

import ScreenSaver

class BallFollow: ScreenSaverView {

    // MARK: - Variables -----------------------------------------------------------
    private var ballList:    [Ball]  = []
    private var debugOutput:    String  = ""
    private var colorToggle:    Bool    = true
    private var waitCount:      Int     = 3
    private let maxBalls:       Int     = 800
    private let variability:    CGFloat = 20
    private let startingSpeed:  CGFloat = 40
    private let leadBallRadius: CGFloat = 25
    
    // MARK: - Initialization ------------------------------------------------------
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        //Add the first ball to the list
        ballList.append(Ball(.white, radius: leadBallRadius))
        
        //Set Position
        let xInit = CGFloat.random(in: 10...(frame.width  - 10))
        let yInit = CGFloat.random(in: 10...(frame.height - 10))
        ballList[0].position = CGPoint(x: xInit,y: yInit)
        
        //Set Velocity
        let xVelocity: CGFloat = startingSpeed
        let yVelocity: CGFloat = startingSpeed
        let xSign: CGFloat = Bool.random() ? 1 : -1
        let ySign: CGFloat = Bool.random() ? 1 : -1
        ballList[0].velocity = CGVector(dx: xVelocity * xSign, dy: yVelocity * ySign)
    }
    
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -----------------------------------------------------------
    // This function will update the "state" of the screensaver
    override func animateOneFrame() {
        super.animateOneFrame()
        
        //Check for out of bounds
        let oobAxes = checkOutOfBounds(b: ballList[0])
        
        //With each collision add a ball
        if (oobAxes.xAxis || oobAxes.yAxis) && ballList.count < maxBalls {
            
            if colorToggle {
                ballList.append(Ball(.blue, radius: CGFloat.random(in:  0...leadBallRadius)))
                colorToggle = false
            }
            else {
                ballList.append(Ball(.systemBlue, radius: CGFloat.random(in:  0...leadBallRadius)))
                colorToggle = true
            }
        }

        //For each ball
        for index in stride(from: ballList.count - 1, to: 0, by: -1) {
            ballList[index].position.x = ballList[index - 1].position.x + CGFloat.random(in:  -variability...variability)
            ballList[index].position.y = ballList[index - 1].position.y + CGFloat.random(in:  -variability...variability)
            ballList[index].velocity = ballList[index - 1].velocity
            
        }
        
        //Handle the lead ball
        if oobAxes.xAxis {
            ballList[0].velocity.dx *= -1
            
        }
        
        if oobAxes.yAxis {
            ballList[0].velocity.dy *= -1
        }
        
        var x_mult: CGFloat = CGFloat.random(in:  -variability...0)
        var y_mult: CGFloat = CGFloat.random(in:  -variability...0)
        
        if ballList[0].velocity.dx > 0 {
            x_mult *= -1
        }
        
        if ballList[0].velocity.dy > 0 {
            y_mult *= -1
        }
        
        ballList[0].position.x += ballList[0].velocity.dx + x_mult
        ballList[0].position.y += ballList[0].velocity.dy + y_mult
        
        // This is for the OS to know that we wish to redraw the screen
        setNeedsDisplay(bounds)
    }
    
    // This function will draw up a single frame
    override func draw(_ rect: NSRect) {
        //drawDebugging()
        drawBackground()
        for b in ballList {
            drawBall(b: b)
        }
    }
    // MARK: - General Helpers -----------------------------------------------------
    
    private func checkOutOfBounds(b: Ball) -> (xAxis: Bool, yAxis: Bool) {
        let xAxisOOB = b.position.x - b.radius <= 0 ||
            b.position.x + b.radius >= bounds.width
        let yAxisOOB = b.position.y - b.radius <= 0 ||
            b.position.y + b.radius >= bounds.height
        return (xAxisOOB, yAxisOOB)
    }
    
    private func drawBackground() {
        let background = NSBezierPath(rect: bounds)
        NSColor.black.setFill()
        background.fill()
    }

    private func drawBall(b: Ball) {
        
        let ballRect = NSRect(x: b.position.x - b.radius,
                              y: b.position.y - b.radius,
                              width:  b.radius * 2,
                              height: b.radius * 2)
        
        let ballSprite = NSBezierPath(roundedRect: ballRect,
                                      xRadius: b.radius,
                                      yRadius: b.radius)
        b.color.setFill()
        ballSprite.fill()
    }
    
    private func drawDebugging() {
        
        debugOutput = "BallList[0]: P:" + ballList[0].position.debugDescription +
                        "\n V: " + ballList[0].velocity.debugDescription
        
        let debugTextView = NSTextView(frame: bounds.insetBy(dx: 50, dy: 50))
        debugTextView.font = .labelFont(ofSize: 10)
        debugTextView.string = debugOutput
        
        self.addSubview(debugTextView)
        
    }
}
