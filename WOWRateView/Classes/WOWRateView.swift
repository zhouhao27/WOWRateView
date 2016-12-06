//
//  WOWRateView.swift
//  Pods
//
//  Created by Zhou Hao on 06/12/16.
//
//

import UIKit

public protocol WOWRateViewDelegate: class {
    func rateView(_ rateView: WOWRateView, didUpdateRating rating: Float)
}

@IBDesignable
public class WOWRateView: UIView {
    
    // MARK: - Constants
    let DefaultRateViewFrame = CGRect(x: 0, y: 0, width: 150, height: 30)
    let DefaultStarNormalColor = UIColor.darkGray
    let DefaultStarFillColor = UIColor.lightGray
    let DefaultStarBorderColor = UIColor.white
    let DefaultStarSize: CGFloat = 30.0
    let DefaultPadding = 0.0
    let DefaultStarCount = 5
    let MinimumRating:Float = 0.0
    let MaximumRating:Float = 5.0
    let TagOffset = 10000

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.backgroundColor = UIColor.clear
        self.step = 0.0
        if rating > MaximumRating {
            self.rating = MaximumRating
        }
        else if rating < MinimumRating {
            self.rating = MinimumRating
        }
        
        self.isCanRate = false
        self.starNormalColor = DefaultStarNormalColor
        self.starFillColor = DefaultStarFillColor
        self.starBorderColor = DefaultStarBorderColor
        self.starFillMode = .horizontal
        self.starSize = DefaultStarSize
        self.rating = 0
        self.starCount = DefaultStarCount
    }
    
    convenience public init(rating: Float) {
        self.init(rating: rating, andFrame: CGRect(x: 0, y: 0, width: 150, height: 30))
    }
    
    init(rating: Float, andFrame newFrame: CGRect) {
        super.init(frame:newFrame)
        
        self.backgroundColor = UIColor.clear
        self.rating = rating
        self.starCount = DefaultStarCount
        self.step = 0.0
        if rating > MaximumRating {
            self.rating = MaximumRating
        }
        else if rating < MinimumRating {
            self.rating = MinimumRating
        }
        
        self.isCanRate = false
        self.starNormalColor = DefaultStarNormalColor
        self.starFillColor = DefaultStarFillColor
        self.starBorderColor = DefaultStarBorderColor
        self.starFillMode = .horizontal
        self.starSize = DefaultStarSize
    }
    
    // MARK: Properties
    public weak var delegate: WOWRateViewDelegate?
    
    // Rating to be used with RateView (0.0 to 5.0)
    public var rating: Float = 0.0 {
        didSet {
            guard starCount > 0 else {
                return
            }

//            self.updateRateView()
            // Update Stars appearance for currentValue
            for i in 1...starCount {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                if rating >= Float(i) {
                    star.currentValue = 1.0
                }
                else {
                    let expectedRating: Float = rating - Float(i - 1)
                    star.currentValue = CGFloat((expectedRating < 0.0) ? 0.0 : Double(expectedRating))
                }
            }
            // Notify the delegate object about rating change
            delegate?.rateView(self, didUpdateRating: rating)
        }
    }
    
    // User can rate using rate view or not (Permission flag)
    public var isCanRate = false
    
    // Rating step when user can rate (0.0 to 1.0)
    public var step: Float = 0.0 {
        willSet {
            if (newValue < 0.0) {
                self.step = 0.0
            }
            else if (newValue > 1.0) {
                self.step = 1.0
            }
            else {
                self.step = newValue
            }
        }
    }
    
    // Number of stars to display
    public var starCount = 0 {
        willSet {
            if starCount == newValue {
                return
            }
            self.starCount = newValue
            self.subviews.forEach { $0.removeFromSuperview() }
            self.updateRateView()
        }
    }
    
    // Star Normal, Fill & Border Colors
    public var starNormalColor: UIColor! {
        didSet {
//            self.updateRateView()
            
            guard starCount > 0 else {
                return
            }
            // Update Stars appearance for color
            for i in 1...starCount {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                star.color = starNormalColor
            }
        }
    }
    
    public var starFillColor: UIColor! {
        didSet {
//            self.updateRateView()
            
            guard starCount > 0 else {
                return
            }

            // Update Stars appearance for fillColor
            for i in 1...starCount
            {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                star.fillColor = starFillColor;
            }
        }
    }
    
    public var starBorderColor: UIColor! {
        didSet {
            guard starCount > 0 else {
                return
            }

//            self.updateRateView()
            // Update Stars appearance for borderColor
            for i in 1...starCount {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                star.borderColor = starBorderColor
            }
        }
    }
    
    // Star Fill modes Horizontal, Vertical or Axial, starSize in points
    public var starFillMode : StarFillMode = .invalid {
        didSet {
            guard starCount > 0 else {
                return
            }

//            self.updateRateView()
            // Update Stars appearance for fillMode
            for i in 1...starCount {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                star.fillMode = starFillMode
            }
        }
    }
    
    public var starSize: CGFloat = 0.0 {
        didSet {
            guard starCount > 0 else {
                return
            }

//            self.updateRateView()
            // Update Stars appearance for size
            for i in 1...starCount {
                let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                star.size = starSize
                star.frame = CGRect(x: CGFloat(i - 1) * (starSize + padding), y: 0, width: CGFloat(starSize), height: CGFloat(starSize))
            }
        }
    }
    
    public var padding: CGFloat = 0.0 {
        willSet {
            guard starCount > 0 else {
                return
            }

            if newValue >= 0.0 {
                self.padding = newValue
                self.frame = CGRect(x: CGFloat(self.frame.origin.x), y: CGFloat(self.frame.origin.y), width: CGFloat(starCount) * starSize + CGFloat(starCount - 1) * padding, height: CGFloat(starSize))
                var newFrame = self.frame
                newFrame.size.width = CGFloat(starCount) * starSize + CGFloat(starCount - 1) * padding
                self.frame = newFrame
                self.updateRateView()
                // Update Stars appearance for size
                for i in 1...starCount {
                    let star = (self.viewWithTag(TagOffset + i)! as! WOWStarView)
                    star.size = starSize
                    star.frame = CGRect(x: CGFloat(i - 1) * (starSize + padding), y: 0, width: CGFloat(starSize), height: CGFloat(starSize))
                }
            }
        }
    }
    
//    override public var frame: CGRect {
//        didSet {
//            if frame.size.width != (CGFloat(starCount) * starSize + CGFloat(starCount - 1) * padding) || frame.size.height != starSize {
//                frame.size.width = CGFloat(starCount) * starSize + CGFloat(starCount - 1) * padding
//                frame.size.height = starSize
//            }
//        }
//    }
    
    // MARK: - private methods
    private func updateRateView() {
        // Update frame for self to accommodate desired width for _starCount stars
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: CGFloat(starCount) * starSize + CGFloat(starCount - 1) * padding, height: starSize)
        // Check if stars have been added to self previously or not
        if self.subviews.count == 0 {
            // If not, add _starCount stars to self with desired frames
            for i in 1...starCount {
                let star = WOWStarView(color: starNormalColor, fill: starFillColor, origin: CGPoint(x: CGFloat(i - 1) * (starSize + padding), y: 0), andSize: starSize)
                self.addSubview(star)
                star.tag = TagOffset + i
            }
        }
    }
    
    // MARK: UIResponder
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        handleTouches(touches)
    }
    
    private func handleTouches(_ touches: Set<UITouch>) {
        if isCanRate {
            let location = touches.first!.location(in: self)
            // Compute location
            var x: CGFloat = location.x
            if x < 0.0 {
                x = 0.0
            }
            else if x > self.frame.size.width {
                x = self.frame.size.width - CGFloat(starCount - 1) * padding
            }
            else if self.step > 0 {
                //            float div = (self.frame.size.width * self.step) / _starCount;
                //            x = (x / div) + self.step;
                //            x = div * (int)x;
                let div: CGFloat = (self.frame.size.width - CGFloat(starCount - 1) * padding * (CGFloat(self.step) / CGFloat(starCount)))
                let p: CGFloat = x / (starSize + padding)
                let q: CGFloat = x - p * (starSize + padding)
                if q > starSize {
                    x = p * starSize + starSize
                }
                else {
                    x = p * starSize + q
                }
                x = (x / div) + CGFloat(self.step)
                x = div * CGFloat(x)
            }
            
            self.rating = Float(x) / Float(starSize)
        }
    }

    // MARK: Autolayout
    override public var intrinsicContentSize: CGSize {
        return CGSize(width:self.starSize * CGFloat(self.starCount) + CGFloat(self.starCount - 1) * self.padding, height:self.starSize)
    }
    
}
