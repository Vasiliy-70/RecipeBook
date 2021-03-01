//
//  CartViewPresenter.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol ICartViewPresenter: class {
	var ingredientsList: [IngredientContent] { get }
	func viewWillAppear()
	func actionTapRow()
	func actionRefreshButtonTabBar()
	func actionTrashButtonTabBar()
	func actionRightSwipe()
}

final class CartViewPresenter {
	private weak var view: ICartViewController?
	private var coordinateController: ICoordinateController
	private var queryModel: IQueryService?
	
	private var ingredientsInfo = [IngredientContent]() {
		didSet {
			self.view?.updateData()
		}
	}
	
	private var ingredientsModel = [Ingredient]() {
		didSet {
			self.ingredientsInfo.removeAll()
			for ingredient in ingredientsModel {
				if let name = ingredient.name {
					var ingredientList = IngredientContent()
					ingredientList.id = ingredient.id
					ingredientList.name = name
					ingredientList.isMarked = ingredient.isMarked
					self.ingredientsInfo.append(ingredientList)
				}
			}
		}
	}
	
	public init(view: ICartViewController, coordinateController: ICoordinateController, queryModel: IQueryService) {
		self.view = view
		self.coordinateController = coordinateController
		self.queryModel = queryModel
	}
}

private extension CartViewPresenter {
	func requestData() {
		self.ingredientsModel = []
		let selectedRecipes = self.queryModel?.fetchRequestSelectedRecipes() ?? []
		for recipe in selectedRecipes {
			if let recipeID = recipe.id {
				self.ingredientsModel += self.queryModel?.fetchRequestIngredientsAt(recipeID: recipeID) ?? []
			}
		}
	}
	
	func resetMarkIngredients() {
		var ingredientContent = IngredientContent()
		for ingredient in self.ingredientsInfo {
			ingredientContent.id = ingredient.id
			ingredientContent.name = ingredient.name
			ingredientContent.isMarked = false
			self.queryModel?.changeIngredient(content: ingredientContent)
		}
	}
}

// MARK: ICartViewPresenter

extension CartViewPresenter: ICartViewPresenter {
	func actionRightSwipe() {
		(self.view as? UIViewController)?.tabBarController?.selectedIndex = 0
	}
	
	func actionTrashButtonTabBar() {
		self.resetMarkIngredients()
		let selectedRecipes = self.queryModel?.fetchRequestSelectedRecipes() ?? []
		for recipe in selectedRecipes {
			var recipeContent = RecipeContent()
			recipeContent.id = recipe.id
			recipeContent.name = recipe.name
			recipeContent.image = UIImage(data: recipe.image ?? Data())
			recipeContent.definition = recipe.definition
			recipeContent.isSelected = false
			self.queryModel?.changeRecipe(content: recipeContent)
			
			NotificationCenter.default.post(name: NotificationModel.recipeUpdated, object: AnyObject.self)
		}
		self.requestData()
	}
	
	func actionRefreshButtonTabBar() {
		self.resetMarkIngredients()
		self.requestData()
	}
	
	func actionTapRow() {
		if let index = self.view?.selectedRow {
			var ingredient = IngredientContent()
			ingredient.id = self.ingredientsModel[index].id
			ingredient.name = self.ingredientsModel[index].name
			ingredient.isMarked = !self.ingredientsModel[index].isMarked
			self.queryModel?.changeIngredient(content: ingredient)
		}
		self.requestData()
	}
	
	var ingredientsList: [IngredientContent] {
		self.ingredientsInfo
	}

	func viewWillAppear() {
		self.requestData()
	}
}
