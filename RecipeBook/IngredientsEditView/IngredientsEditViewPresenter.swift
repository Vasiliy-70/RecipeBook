//
//  IngredientsEditViewPresenter.swift
//  FinalWork
//
//  Created by Боровик Василий on 15.12.2020.
//

import CoreData
import UIKit

protocol IIngredientsEditViewPresenter: class {
	var ingredientList: [String] { get }
	func actionTapRow()
	func actionDeleteRow()
	func actionApplyButton(modalMode: Bool)
	func actionCancelButton()
	func actionAddButton()
	func actionEditCellAlert(newName: String)
	func viewWillAppear()
}

final class IngredientsEditViewPresenter {
	private weak var view: IIngredientsEditViewController?
	private var coordinateController: ICoordinateController
	private var queryModel: IQueryService?
	private var recipeID: UUID
	private var isNewIngredientEdit = false
	
	private var ingredientName = [String]() {
		didSet {
			self.view?.updateData()
		}
	}
	
	private var ingredientModel = [Ingredient]() {
		didSet {
			self.ingredientName.removeAll()
			for ingredient in ingredientModel {
				if let name = ingredient.name {
					self.ingredientName.append(name)
				}
			}
		}
	}
	
	public init(view: IngredientsEditViewController, coordinateController: ICoordinateController, queryModel: IQueryService, recipeID: UUID) {
		self.view = view
		self.coordinateController = coordinateController
		self.queryModel = queryModel
		self.recipeID = recipeID
	}
}

private extension IngredientsEditViewPresenter {
	func requestData() {
		self.ingredientModel = self.queryModel?.fetchRequestIngredientsAt(recipeID: self.recipeID) ?? []
	}
}

// MARK: IMainViewController

extension IngredientsEditViewPresenter: IIngredientsEditViewPresenter {
	func actionCancelButton() {
		(self.view as? UIViewController)?.dismiss(animated: true, completion: nil)
	}
	
	func actionEditCellAlert(newName: String) {
		var ingredient = IngredientContent()
		ingredient.name = newName
		if self.isNewIngredientEdit {
			self.queryModel?.addIngredient(info: ingredient, recipeID: self.recipeID)
		} else {
			if let index = self.view?.selectedRow {
				ingredient.id = self.ingredientModel[index].id
				self.queryModel?.changeIngredient(content: ingredient)
			}
		}
		self.requestData()
	}
	
	func actionApplyButton(modalMode: Bool) {
		if !modalMode {
			(self.view as? UIViewController)?.navigationController?.popToRootViewController(animated: true)
		} else {
			(self.view as? UIViewController)?.dismiss(animated: true, completion: nil)
		}
	}
	
	var ingredientList: [String] {
		self.ingredientName
	}
	
	func actionTapRow() {
		self.isNewIngredientEdit = false
		if let index = self.view?.selectedRow {
			let ingredientName = self.ingredientName[index]
			self.view?.showAlertIngredients(title: "Имя ингредиента", message: "Введите новое значение", textValue: ingredientName)
		}
	}
	
	func actionDeleteRow() {
		if let index = self.view?.selectedRow,
		   let id = self.ingredientModel[index].id {
			self.queryModel?.removeIngredientAt(id: id)
			self.requestData()
		}
	}
	
	func actionAddButton() {
		self.isNewIngredientEdit = true
		self.view?.showAlertIngredients(title: "Имя ингредиента", message: "Введите новое значение", textValue: "")
	}
	
	func viewWillAppear() {
		self.requestData()
	}
}
