//
//  CoordinateController.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

protocol ICoordinateController: class {
	func showMainView()
	func showRecipeEditView(recipeID: UUID?, modalMode: Bool)
	func showIngredientsEditView(recipeID: UUID, modalMode: Bool)
	func showRecipeView(recipeID: UUID)
	func showIngredientView(recipeID: UUID)
}

final class CoordinateController {
	private var navigationController: UINavigationController?
	private var queryModel = QueryService()
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
}

// MARK: ICoordinateController

extension CoordinateController: ICoordinateController {
	func showMainView() {
		guard let navigationController = self.navigationController
		else {
			assertionFailure("Error show MainView")
			return
		}
		
		let mainViewController = MainViewAssembly.createMainViewController(coordinateController: self, queryModel: self.queryModel)
		let cartViewController = CartViewAssembly.createCartView(coordinateController: self, queryModel: self.queryModel)
		
		let tabBar = TabBarControllerExtended()
		tabBar.setViewControllers([mainViewController, cartViewController], animated: true)
		
		navigationController.pushViewController(tabBar, animated: true)
	}
	
	func showIngredientsEditView(recipeID: UUID, modalMode: Bool) {
		guard let navigationController = self.navigationController
		else {
			assertionFailure("Error show IngredientsEditView")
			return
		}
		
		let ingredientsEditView = IngredientsEditViewAssembly.createIngredientsEditView(coordinateController: self, queryModel: self.queryModel, recipeID: recipeID, modalMode: modalMode)
		
		if modalMode {
			let modalNavigationController = UINavigationController(rootViewController: ingredientsEditView)
			navigationController.present(modalNavigationController, animated: true, completion: nil)
		} else {
			navigationController.pushViewController(ingredientsEditView, animated: true)
		}
	}
	
	func showRecipeEditView(recipeID: UUID?, modalMode: Bool) {
		guard let navigationController = self.navigationController
		else {
			assertionFailure("Error show RecipeEditView")
			return
		}
		
		let recipeEditView = RecipeEditViewAssembly.createRecipeEditViewController(coordinateController: self,queryModel: self.queryModel, recipeID: recipeID, modalMode: modalMode)
		
		if modalMode {
			let modalNavigationController = UINavigationController(rootViewController: recipeEditView)
			navigationController.present(modalNavigationController, animated: true, completion: nil)
		} else {
			navigationController.pushViewController(recipeEditView, animated: true)
		}
	}
	
	func showRecipeView(recipeID: UUID) {
		guard let navigationController = self.navigationController
		else {
			assertionFailure("Error show RecipeView")
			return
		}
		
		let recipeView = RecipeViewAssembly.createRecipeView(coordinateController: self, queryModel: queryModel, recipeID: recipeID)
		let ingredientsView = IngredientsViewAssembly.createIngredientsView(coordinateController: self, queryModel: queryModel, recipeID: recipeID)
		
		let tabBar = TabBarControllerExtended()
		tabBar.setViewControllers([recipeView, ingredientsView], animated: true)
		
		navigationController.pushViewController(tabBar, animated: true)
	}
	
	func showIngredientView(recipeID: UUID) {
		guard let navigationController = self.navigationController
		else {
			assertionFailure("Error show IngredientsView")
			return
		}
		
		let ingredientsView = IngredientsViewAssembly.createIngredientsView(coordinateController: self, queryModel: queryModel, recipeID: recipeID)
		navigationController.pushViewController(ingredientsView, animated: true)
	}
}

