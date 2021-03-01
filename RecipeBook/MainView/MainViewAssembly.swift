//
//  MainViewAssembly.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

enum MainViewAssembly {
	static func createMainViewController(coordinateController: ICoordinateController, queryModel: IQueryService) -> UIViewController {
		let view = MainViewController()
		let presenter = MainViewPresenter(view: view, coordinateController: coordinateController, queryModel: queryModel)
		view.presenter = presenter
		return view
	}
}
