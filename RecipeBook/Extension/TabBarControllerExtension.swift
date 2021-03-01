//
//  TabBarControllerExtension.swift
//  FinalWork
//
//  Created by Боровик Василий on 17.12.2020.
//
import UIKit

class TabViewController {
	
}

extension TabViewController: UITabBarControllerDelegate {
	  public func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {

		   let fromView: UIView = tabBarController.selectedViewController!.view
		   let toView  : UIView = viewController.view
		   if fromView == toView {
				 return false
		   }

		   UIView.transitionFromView(fromView, toView: toView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve) { (finished:Bool) in

		}
		return true
   }
}
