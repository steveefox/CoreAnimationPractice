//
//  SignInViewController.swift
//  CoreAnimationPractice
//
//  Created by Nikita on 28.01.23.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    // MARK: Appearance
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        signInButton.round(cornerRadius: 10, borderWidth: 3, borderColor: UIColor.white)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signInButton.layer.position.y += AnimationHelper.screenBounds.height
        
        fadeInViews()
    }
    
    // MARK: User Actions
    @IBAction func SignInOnButtonPressed(_ sender: Any) {
        // TODO: Add button pop
        animateButtonClick()
        
        segueToNextViewController(segueID: Constants.Segues.loadingVC, withDelay: 1.0)
    }
    
    // MARK: Animations
    func fadeInViews() {
        let fade = AnimationHelper.basicFadeAnimation()
        fade.delegate = self
        titleLabel.layer.add(fade, forKey: nil)
        
        fade.beginTime = AnimationHelper.addDelay(time: 1.0)
        usernameField.layer.add(fade, forKey: nil)
        
        fade.beginTime = AnimationHelper.addDelay(time: 2.0)
        fade.setValue("password", forKey: "animation_name")
        passwordField.layer.add(fade, forKey: nil)
    }
    
    func animateButtonWithSpring() {
        let moveUp = CASpringAnimation(keyPath: AnimationHelper.posY)
        moveUp.delegate = self
        moveUp.setValue("sign_in", forKey: "animation_name")
        moveUp.setValue(signInButton.layer, forKey: "object_layer")
        
        moveUp.fromValue = signInButton.layer.position.y + AnimationHelper.screenBounds.height
        moveUp.toValue = signInButton.layer.position.y - AnimationHelper.screenBounds.height
        moveUp.duration = moveUp.settlingDuration
        //moveUp.beginTime = AnimationHelper.addDelay(time: 2.5)
        //moveUp.fillMode = kCAFillModeBackwards
        
        // Spring physics properties
        moveUp.initialVelocity = 5
        moveUp.mass = 1
        moveUp.stiffness = 75
        moveUp.damping = 12
        
        signInButton.layer.position.y -= AnimationHelper.screenBounds.height
        signInButton.layer.add(moveUp, forKey: nil)
    }
    
    func animateButtonClick() {
        let pop = CASpringAnimation(keyPath: AnimationHelper.scale)
        
        pop.fromValue = 1.2
        pop.toValue = 1
        pop.duration = pop.settlingDuration
        pop.initialVelocity = 2
        pop.damping = 10
        
        signInButton.layer.add(pop, forKey: "pop")
    }
    
    func animateBorderColorPulse() -> CABasicAnimation {
        let colorFade = CABasicAnimation(keyPath: AnimationHelper.borderColor)
        
        colorFade.fromValue = UIColor.clear.cgColor
        colorFade.toValue = UIColor.white.cgColor
        colorFade.duration = 1.0
        colorFade.timingFunction = CAMediaTimingFunction(name: .easeIn)
        colorFade.speed = 2
        colorFade.repeatCount = .infinity
        colorFade.autoreverses = true
        
        return colorFade
    }
}

// MARK: Delegate Extensions
extension SignInViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let animName = anim.value(forKey: "animation_name") as? String else {
            return
        }
        
        switch animName {
        case "password":
            animateButtonWithSpring()
        case "sign_in":
            let animLayer = anim.value(forKey: "object_layer") as? CALayer
            animLayer?.add(animateBorderColorPulse(), forKey: "borderColor_pulse")
            print(animLayer?.animationKeys() ?? "No keys found...")
        default:
            break
        }
    }
}

