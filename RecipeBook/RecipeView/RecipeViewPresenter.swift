//
//  RecipeViewPresenter.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol IRecipeViewPresenter {
	var recipe: RecipeContent { get }
	func viewWillDidLoad()
	func actionCartButtonTabBar()
	func actionEditButtonTabBar()
	func actionLeftSwipe()
	func notificationCame()
}

final class RecipeViewPresenter {
	private var view: IRecipeViewController
	private var coordinateController: ICoordinateController
	private var queryModel: IQueryService
	private var recipeID: UUID
	
	private var recipeInfo = RecipeContent() {
		didSet {
			self.view.updateData()
		}
	}
	
	private var recipeModel = [Recipe]() {
		willSet {
			recipeInfo = RecipeContent()
			recipeInfo.id = self.recipeID
			recipeInfo.name = newValue.first?.name
			recipeInfo.definition = newValue.first?.definition
			recipeInfo.image = UIImage(data: newValue.first?.image ?? Data())
			recipeInfo.isSelected = newValue.first?.isSelected
		}
	}
	
	init(view: IRecipeViewController, coordinateController: ICoordinateController, queryModel: IQueryService, recipeID: UUID) {
		self.view = view
		self.coordinateController = coordinateController
		self.queryModel = queryModel
		self.recipeID = recipeID
	}
}

private extension RecipeViewPresenter {
	func requestData() {
		self.recipeModel = self.queryModel.fetchRequestRecipesAt(id: self.recipeID) ?? []
	}
}

// MARK: IRecipeViewPresenter

extension RecipeViewPresenter: IRecipeViewPresenter {
	func notificationCame() {
		self.requestData()
	}
	
	func actionLeftSwipe() {
		(self.view as? UIViewController)?.tabBarController?.selectedIndex = 1
	}
	
	func actionEditButtonTabBar() {
		self.coordinateController.showRecipeEditView(recipeID: self.recipeID,
															  modalMode: true)
	}
	
	func actionCartButtonTabBar() {
		if let isSelected = self.recipeInfo.isSelected,
		   isSelected {
			self.recipeInfo.isSelected = false
			self.view.showAlert(message: "Рецепт убран из корзины")
		} else {
			self.recipeInfo.isSelected = true
			self.view.showAlert(message: "Рецепт добавлен в корзину")
		}
	
		self.queryModel.changeRecipe(content: self.recipeInfo)
		
		NotificationCenter.default.post(name: NotificationModel.recipeUpdated, object: AnyObject.self)
	}
	
	var recipe: RecipeContent {
		self.recipeInfo
	}
	
	func viewWillDidLoad() {
		self.requestData()
	}
}
