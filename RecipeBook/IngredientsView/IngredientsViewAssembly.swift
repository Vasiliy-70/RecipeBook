//
//  IngredientsViewAssembly.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

enum IngredientsViewAssembly {
	static func createIngredientsView(coordinateController: ICoordinateController, queryModel: IQueryService, recipeID: UUID) -> UIViewController {
		let view = IngredientsViewController()
		let presenter = IngredientsViewPresenter(view: view, coordinateController: coordinateController, queryModel: queryModel, recipeID: recipeID)
		view.presenter = presenter
		return view
	}
}
