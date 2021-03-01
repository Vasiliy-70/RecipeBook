//
//  IngredientsViewPresent.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol IIngredientsViewPresenter: class {
	var ingredientsList: [String] { get }
	func viewWillAppear()
	func actionEditButtonTabBar()
	func actionRightSwipe()
	func notificationCame()
}

final class IngredientsViewPresenter {
	private weak var view: IIngredientsViewController?
	private var coordinateController: ICoordinateController
	private var queryModel: IQueryService?
	private var recipeID: UUID
	
	private var ingredientsName = [String]() {
		didSet {
			self.view?.updateData()
		}
	}
	
	private var ingredientsModel = [Ingredient]() {
		didSet {
			self.ingredientsName.removeAll()
			for ingredient in ingredientsModel {
				if let name = ingredient.name {
					self.ingredientsName.append(name)
				}
			}
		}
	}
	
	public init(view: IIngredientsViewController, coordinateController: ICoordinateController, queryModel: IQueryService, recipeID: UUID) {
		self.view = view
		self.coordinateController = coordinateController
		self.queryModel = queryModel
		self.recipeID = recipeID
	}
}

private extension IngredientsViewPresenter {
	func requestData() {
		self.ingredientsModel = self.queryModel?.fetchRequestIngredientsAt(recipeID: self.recipeID) ?? []
	}
}

// MARK: IIngredientsViewPresenter

extension IngredientsViewPresenter: IIngredientsViewPresenter {
	func notificationCame() {
		self.requestData()
	}
	
	func actionRightSwipe() {
		(self.view as? UIViewController)?.tabBarController?.selectedIndex = 0
	}
	
	func actionEditButtonTabBar() {
		self.coordinateController.showIngredientsEditView(recipeID: self.recipeID, modalMode: true)
	}
	
	var ingredientsList: [String] {
		self.ingredientsName
	}

	func viewWillAppear() {
		self.requestData()
	}
}
