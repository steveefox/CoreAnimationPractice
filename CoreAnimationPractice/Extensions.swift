//
//  Extensions.swift
//  CoreAnimationPractice
//
//  Created by Nikita on 28.01.23.
//

import UIKit

extension UIView {
    func round(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
    }
}

extension NSObject {
    public func delayForSeconds(delay: Double, completion: @escaping() -> ()) {
        let timer = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: timer) {
            completion()
        }
    }
}

extension UIViewController {
    func segueToNextViewController(segueID: String, withDelay: Double) {
        delayForSeconds(delay: withDelay) {
            self.performSegue(withIdentifier: segueID, sender: nil)
        }
    }
}

extension UIApplication {
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        let defaultInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        return keyWindow?.safeAreaInsets ?? defaultInsets
    }
}
