//
//  WOWStarView.swift
//  Pods
//
//  Created by Zhou Hao on 06/12/16.
//
//

import UIKit

public enum StarFillMode : Int {
    case invalid = 0
    case horizontal
    case vertical
    case axial
}

class WOWStarView: UIView {
    
    //color - Normal Background Color (Unfilled)
    var color: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //fillColor - Filled Upto Current Value
    var fillColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //borderColor - Border Color for Star
    var borderColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //fillMode - can be Horizontal, Vertical, Axial
    var fillMode : StarFillMode = .invalid {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //currentValue - upto which Star is to be filled
    var currentValue: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //size - Star size
    var size: CGFloat = 0.0 {
        didSet {
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: size, height: size)
            setNeedsDisplay()
        }
    }
    
    convenience init(color: UIColor, fill fillColor: UIColor, origin: CGPoint, andSize size: CGFloat) {
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: size, height: size))
        
        // By default, background doesn't have any color
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        // Assign the color, fillColor & other defaults
        self.color = color
        self.fillColor = fillColor
        self.borderColor = UIColor.white
        
        self.fillMode = .horizontal
        self.currentValue = 0.0
    }
    
    override func draw(_ rect: CGRect) {
        // Get Current Context & Clear for transparent background
        if let context = UIGraphicsGetCurrentContext() {
            
            context.clear(rect)
            
            /*
             * We expect a square for the 'rect',
             * so arm = rect.size.width = rect.size.height
             */
            let arm = rect.size.width
            
            // Create a path for star shape
            let path = CGMutablePath()
            path.move(to: CGPoint(x: arm*0.0, y: arm*0.35))
            path.addLine(to: CGPoint(x: arm*0.35, y: arm*0.35))
            path.addLine(to: CGPoint(x: arm*0.50, y: arm*0.0))
            path.addLine(to: CGPoint(x: arm*0.65, y: arm*0.35))
            path.addLine(to: CGPoint(x: arm*1.00, y: arm*0.35))
            path.addLine(to: CGPoint(x: arm*0.75, y: arm*0.60))
            path.addLine(to: CGPoint(x: arm*0.85, y: arm*1.00))
            path.addLine(to: CGPoint(x: arm*0.50, y: arm*0.75))
            path.addLine(to: CGPoint(x: arm*0.15, y: arm*1.00))
            path.addLine(to: CGPoint(x: arm*0.25, y: arm*0.60))
            path.addLine(to: CGPoint(x: arm*0.0, y: arm*0.35))
            
            /*
             * Add this path's copy(Only for border) to context, stroke it for the border to appear.
             * Add the original path to context, Clip the context for this path.
             * This way, we will be able to draw inside star shaped path only
             */
            context.saveGState()
            
            let pathCopy = path.copy()
            
            context.addPath(pathCopy!)
            //CGPathRelease(pathCopy!)
            
            context.setLineWidth(1)
            context.setStrokeColor(self.borderColor.cgColor)
            context.strokePath()
            
            context.addPath(path)
            context.clip()
            
            // Fill the color in Star for regular backgroundColor
            context.setFillColor(color.cgColor);
            context.fill(rect);
            
            // Decide where to start filling & upto where it's gonna be
            var source = CGPoint.zero
            var destination = CGPoint.zero
            
            if(self.fillMode == .horizontal)
            {
                // left arm mid point
                source = CGPoint(x:0, y:arm/2)
                
                // progress x++
                destination = CGPoint(x: currentValue*arm, y: arm/2)
            }
            else if(self.fillMode == .vertical)
            {
                // bottom arm mid point
                source = CGPoint(x:arm/2, y:arm)
                
                // progress y--
                destination = CGPoint(x:arm/2, y:arm - self.currentValue*arm);
            }
            else if(self.fillMode == .axial)
            {
                // bottom left corner
                source = CGPoint(x:0, y:arm)
                
                /*
                 * progress should be y-- (arm - _currentValue*arm)
                 * but have to fix instead, it goes diagonally very fast
                 * need to adjust the star shape area coverage a bit
                 * (with y--, 0.75f almost covers it fully)
                 * We know diagonally d*d = x*x + y*y
                 * If (x=y, on axial line), then d*d = 2*x*x
                 * this means x = d/sqrt(2)
                 * it should work, surprisingly in this scenario,
                 * area contained within star does still create problems
                 * y works just fine with sqrt(2) i.e. 1.414
                 * x had to be tuned to 1.07 from 1.5 to 1.0 through Hit-N-Trial
                 * it's the closest I could get to it.
                 * Needs further refinement.
                 */
                
                if (self.currentValue > 0.0) {
                    destination = CGPoint(x:(self.currentValue*arm)/1.07, y:arm - (self.currentValue*arm)/sqrt(2))
                }
                else {
                    destination = source
                }
            }
            
            /*
             * Set fillColor to stroke color,
             * line width thick enough to cover every possible corner of the star
             */
            context.setStrokeColor(fillColor.cgColor)
            context.setLineWidth(2*arm)
            
            /*
             * Add a very thick line from source to destination
             * line's thickness will cover the entire star width
             * giving us the required fill
             */
            context.beginPath()
            
            context.move(to: CGPoint(x:source.x,y:source.y))
            context.addLine(to: CGPoint(x: destination.x, y: destination.y))
            
            context.closePath()
            
            // Stroke the line
            context.strokePath()
            
            // Restore Context State
            context.restoreGState()
            
            //CGPathRelease(path);
        }
    }
}
