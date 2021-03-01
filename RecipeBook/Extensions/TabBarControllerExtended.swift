//
//  TabBarControllerExtended.swift
//  FinalWork
//
//  Created by Боровик Василий on 18.12.2020.
//

import UIKit

final class TabBarControllerExtended: UITabBarController {
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}
}

extension TabBarControllerExtended: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AnimatedTransition(viewControllers: tabBarController.viewControllers)
	}
}
