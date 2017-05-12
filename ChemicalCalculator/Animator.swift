//
//  Animator.swift
//  Pods
//
//  Created by Vivian Liu on 5/4/17.
//
//

import Foundation
import UIKit

class NavDelegate: NSObject, UINavigationControllerDelegate {
    private let animator = Animator()
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationControllerOperation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        if let calculatorVC = fromVC as? CalculatorViewController, calculatorVC.shouldUseCustomAnimation == true {
            return animator
        }
        return nil
    }
}

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.9
    }
    
    func animateTransition(using context: UIViewControllerContextTransitioning) {
        let toVC = context.viewController(forKey: .to)
        let fromVC = context.viewController(forKey: .from)
        let toVCSnapShotView = toVC?.view.resizableSnapshotView(from: (toVC?.view.frame)!, afterScreenUpdates: true, withCapInsets: .zero)
        context.containerView.addSubview((toVC?.view)!)
        toVC?.view.alpha = 0
        UIView.animate(withDuration: 0.9, animations: {
            fromVC?.view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
            let barItemView = (fromVC?.tabBarController?.tabBar.subviews[2])!
            
            fromVC?.view.center = CGPoint(x: barItemView.frame.midX, y: (barItemView.superview?.frame.midY)!)
            toVC?.view.alpha = 1

        }) { (finished) in
            toVCSnapShotView?.removeFromSuperview()
            fromVC?.view.transform = CGAffineTransform.identity
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
