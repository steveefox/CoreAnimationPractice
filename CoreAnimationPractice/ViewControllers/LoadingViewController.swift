//
//  LoadingViewController.swift
//  CoreAnimationPractice
//
//  Created by Nikita on 28.01.23.
//

import UIKit

class LoadingViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var setupLabel: UILabel!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clockImage.round(cornerRadius: clockImage.frame.size.width/2, borderWidth: 4, borderColor: UIColor.black)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let titleAnimGroup = CAAnimationGroup()
        titleAnimGroup.duration = 1.5
        titleAnimGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        titleAnimGroup.repeatCount = .infinity
        titleAnimGroup.autoreverses = true
        titleAnimGroup.animations = [positionPulse(), scalePulse()]
        
        loadingLabel.layer.add(titleAnimGroup, forKey: "title_group")
        
        
        let clockAnimGroup = CAAnimationGroup()
        clockAnimGroup.repeatCount = .infinity
        clockAnimGroup.duration = 3.0
        clockAnimGroup.timingFunction = CAMediaTimingFunction(name: .easeIn)
        clockAnimGroup.animations = [
            createKeyFrameColorAnimation(),
            bounceKeyframeAnimation(),
            rotateKeyframe()
        ]
        clockImage.layer.add(clockAnimGroup, forKey: "clock_group")
        
        delayForSeconds(delay: 2.0) {
            self.animateViewTransition()
        }
        
        segueToNextViewController(segueID: Constants.Segues.dashboardVC, withDelay: 5.0)
    }
    
    func positionPulse() -> CABasicAnimation {
        let posY = CABasicAnimation(keyPath: AnimationHelper.posY)
        posY.fromValue = loadingLabel.layer.position.y - 20
        posY.toValue = loadingLabel.layer.position.y + 20
        
        return posY
    }
    
    func scalePulse() -> CABasicAnimation {
        let scale = CABasicAnimation(keyPath: AnimationHelper.scale)
        scale.fromValue = 1.1
        scale.toValue = 1.0
        
        return scale
    }
    
    // MARK: Keyframe Animations
    func createKeyFrameColorAnimation() -> CAKeyframeAnimation {
        let colorChange = CAKeyframeAnimation(keyPath: AnimationHelper.borderColor)
        colorChange.duration = 1.5
        colorChange.beginTime = AnimationHelper.addDelay(time: 1.0)
        colorChange.values = [
            UIColor.white.cgColor,
            UIColor.yellow.cgColor,
            UIColor.red.cgColor,
            UIColor.black.cgColor
        ]
        
        colorChange.keyTimes = [0.0, 0.25, 0.75, 1.0]
        
        return colorChange
    }
    
    func bounceKeyframeAnimation() -> CAKeyframeAnimation {
        let bounce = CAKeyframeAnimation(keyPath: AnimationHelper.position)
        
        bounce.duration = 3.0
        let safeAreaInsets = UIApplication.safeAreaInsets
        bounce.values = [
            NSValue(cgPoint: CGPoint(x: 25, y: AnimationHelper.screenBounds.height - safeAreaInsets.bottom - 125)),
            NSValue(cgPoint: CGPoint(x: 175, y: AnimationHelper.screenBounds.height - safeAreaInsets.bottom - 200)),
            NSValue(cgPoint: CGPoint(x: 325, y: AnimationHelper.screenBounds.height - safeAreaInsets.bottom - 125)),
            NSValue(cgPoint: CGPoint(x: AnimationHelper.screenBounds.width + 200, y: AnimationHelper.screenBounds.height - safeAreaInsets.bottom - 350))
        ]
        
        bounce.keyTimes = [0.0, 0.3, 0.6, 1.0]
        
        return bounce
    }
    
    func rotateKeyframe() -> CAKeyframeAnimation {
        let rotate = CAKeyframeAnimation(keyPath: AnimationHelper.rotation)
        rotate.values = [0.0, .pi/2.0, Double.pi * 3/2, Double.pi * 2]
        rotate.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0]
        
        return rotate
    }
    
    // MARK: Transitions
    func animateViewTransition() {
        let viewTransition = CATransition()
        
        viewTransition.duration = 1.5
        viewTransition.type = CATransitionType.reveal
        viewTransition.subtype = CATransitionSubtype.fromLeft
        //viewTransition.startProgress = 0.4
        //viewTransition.endProgress = 0.8
        
        loadingLabel.layer.add(viewTransition, forKey: "reveal_left")
        setupLabel.layer.add(viewTransition, forKey: "reveal_left")
        
        loadingLabel.isHidden = true
        setupLabel.isHidden = false
        
        //loadingLabel.alpha = 0
        
    }
    
}

// MARK: Delegate Extensions
extension LoadingViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //guard let animName = anim.value(forKey: "animation_name") as? String else { return }
    }
}
