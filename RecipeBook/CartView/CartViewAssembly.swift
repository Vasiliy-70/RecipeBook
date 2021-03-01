//
//  CartViewAssembly.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

enum CartViewAssembly {
	static func createCartView(coordinateController: ICoordinateController, queryModel: IQueryService) -> UIViewController {
		let view = CartViewController()
		let presenter = CartViewPresenter(view: view, coordinateController: coordinateController, queryModel: queryModel)
		view.presenter = presenter
		return view
	}
}
