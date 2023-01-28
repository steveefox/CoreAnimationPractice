//
//  GradientActions.swift
//  CoreAnimationPractice
//
//  Created by Nikita on 28.01.23.
//

import UIKit

class GradientColorAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        
        let layer = anObject as! CAGradientLayer
        let colorChange = CABasicAnimation(keyPath: AnimationHelper.gradientColors)
        let finalColors = [UIColor.black.cgColor, UIColor.orange.cgColor, UIColor.red.cgColor]
        
        colorChange.duration = 2.0
        colorChange.fromValue = layer.colors
        colorChange.toValue = finalColors
        colorChange.fillMode = .backwards
        colorChange.beginTime = AnimationHelper.addDelay(time: 4.0)
        
        layer.colors = finalColors
        layer.add(colorChange, forKey: "gradient_color_swap")
    }
}

class GradientLocationAction: NSObject, CAAction {
    func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
        
        let layer = anObject as! CAGradientLayer
        let locationChange = CABasicAnimation(keyPath: AnimationHelper.gradientLocations)
        let finalLocations: [NSNumber] = [0.0, 0.9, 1.0]
        
        locationChange.duration = 2.0
        locationChange.fromValue = layer.locations
        locationChange.toValue = finalLocations
        locationChange.beginTime = AnimationHelper.addDelay(time: 1.0)
        locationChange.fillMode = .backwards
        
        layer.locations = finalLocations
        layer.add(locationChange, forKey: "gradient_locations")
    }
}
