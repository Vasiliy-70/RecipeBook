//
//  RecipeViewAssembly.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

enum RecipeViewAssembly {
	static func createRecipeView(coordinateController: ICoordinateController, queryModel: IQueryService, recipeID: UUID) -> UIViewController {
		let view = RecipeViewController()
		let presenter = RecipeViewPresenter(view: view, coordinateController: coordinateController, queryModel: queryModel, recipeID: recipeID)
		view.presenter = presenter
		return view
	}
}
