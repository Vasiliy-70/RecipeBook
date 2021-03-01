//
//  TabBarControllerAnimation.swift
//  FinalWork
//
//  Created by Боровик Василий on 19.12.2020.
//
import UIKit

final class AnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
	private let viewControllers: [UIViewController]?
	private let transitionDuration: Double = 0.2

	init(viewControllers: [UIViewController]?) {
		self.viewControllers = viewControllers
	}

	func transitionDuration(using transitionContext:
								UIViewControllerContextTransitioning?) -> TimeInterval {
		return TimeInterval(self.transitionDuration)
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
			let fromView = fromVC.view,
			let fromIndex = getIndex(forViewController: fromVC),
			let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
			let toView = toVC.view,
			let toIndex = getIndex(forViewController: toVC)
			else {
				transitionContext.completeTransition(false)
				return
		}

		let frame = transitionContext.initialFrame(for: fromVC)
		var fromFrameEnd = frame
		var toFrameStart = frame
		fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
		toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
		toView.frame = toFrameStart

		DispatchQueue.main.async {
			transitionContext.containerView.addSubview(toView)
			
			UIView.animate(withDuration: self.transitionDuration, animations: {
				fromView.frame = fromFrameEnd
				toView.frame = frame
			}, completion: {success in
				fromView.removeFromSuperview()
				transitionContext.completeTransition(success)
			})
		}
	}

	func getIndex(forViewController vc: UIViewController) -> Int? {
		guard let viewControllers = self.viewControllers else { return nil }
		for (index, thisVC) in viewControllers.enumerated() {
			if thisVC == vc { return index }
		}
		return nil
	}
}
