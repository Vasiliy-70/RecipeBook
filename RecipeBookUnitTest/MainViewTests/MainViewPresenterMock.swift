//
//  MainViewPresenterMock.swift
//  FinalWorkTests
//
//  Created by Боровик Василий on 19.12.2020.
//

@testable import RecipeBook

class MainViewPresenterMock: IMainViewPresenter {
	var recipeList: [RecipeContent] {
		get {
			self.recipeListGetResult = true
			return []
		}
	}
	var recipeListGetResult = false
	var actionTapRowResult = false
	var actionDeleteRowResult = false
	var actionAddButtonResult = false
	var viewDidLoadResult = false
	var actionLeftSwipeResult = false
	var notificationCameResult = false
	
	func actionTapRow() {
		self.actionTapRowResult = true
	}
	
	func actionDeleteRow() {
		self.actionDeleteRowResult = true
	}
	
	func actionAddButton() {
		self.actionAddButtonResult = true
	}
	
	func viewDidLoad() {
		self.viewDidLoadResult = true
	}
	
	func actionLeftSwipe() {
		self.actionLeftSwipeResult = true
	}
	
	func notificationCame() {
		self.notificationCameResult = true
	}
}

