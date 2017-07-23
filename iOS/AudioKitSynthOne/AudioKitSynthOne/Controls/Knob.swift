//
//  KnobView.swift
//  SynthUISpike
//
//  Created by Matthew Fecher on 7/20/17.
//  Copyright © 2017 Matthew Fecher. All rights reserved.
//

import UIKit

protocol AKSynthOneControl {
    var value: Double { get set }
}

@IBDesignable
public class Knob: UIView, AKSynthOneControl {

    @IBInspectable var logarithmic: Bool = false
    @IBInspectable var onlyIntegers: Bool = false

    public var callback: (Double)->Void = { _ in }

    @IBInspectable var minimum: Double = 0.0 {
        didSet {
            self.knobValue = CGFloat((value - minimum) / (maximum - minimum))
        }
    }
    @IBInspectable var maximum: Double = 1 {
        didSet {
            self.knobValue = CGFloat((value - minimum) / (maximum - minimum))
        }
    }

    @IBInspectable var value: Double = 0.5 {
        didSet {
            if value > maximum {
                value = maximum
            }
            if value < minimum {
                value = minimum
            }
            if onlyIntegers {
                self.knobValue = CGFloat((round(value) - minimum) / (maximum - minimum))
            } else {
                self.knobValue = CGFloat((value - minimum) / (maximum - minimum))
            }
        }
    }
    
    // Knob properties
    var knobValue: CGFloat = 0.5 {
        didSet {
            setNeedsDisplay()
    
        }
    }
    var knobFill: CGFloat = 0
    var knobSensitivity = 0.005
    var lastX: CGFloat = 0
    var lastY: CGFloat = 0
    
    // Init / Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        contentMode = .scaleAspectFit
        clipsToBounds = true
    }
    
    public class override var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    public override func draw(_ rect: CGRect) {
        KnobStyleKit.drawKnobOne(frame: CGRect(x:0,y:0, width: self.bounds.width, height: self.bounds.height), knobValue: knobValue)
    }
    
    // Helper
    func setPercentagesWithTouchPoint(_ touchPoint: CGPoint) {
        // Knobs assume up or right is increasing, and down or left is decreasing
        
        let horizontalChange = Double(touchPoint.x - lastX) * knobSensitivity
        value += horizontalChange * (maximum - minimum)
        
        let verticalChange = Double(touchPoint.y - lastY) * knobSensitivity
        value -= verticalChange * (maximum - minimum)

        lastX = touchPoint.x
        lastY = touchPoint.y
        
        onlyIntegers ? callback(round(value)) : callback(value)
    }
    
}
