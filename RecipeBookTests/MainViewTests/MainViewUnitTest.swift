//
//  MainViewUnitTest.swift
//  FinalWorkTests
//
//  Created by Боровик Василий on 19.12.2020.
//

import XCTest
@testable import FinalWork

class MainViewUnitTest: XCTestCase {

	private var mainViewPresenter: MainViewPresenterMock!
	private var mainView: MainView!
	private var mainViewController: MainViewController!
	
	override func setUpWithError() throws {
		self.mainViewPresenter = MainViewPresenterMock()
		self.mainViewController = MainViewController()
		self.mainView = MainView(tableController: self.mainViewController)
		self.mainViewController.presenter = self.mainViewPresenter
    }

    override func tearDownWithError() throws {
		self.mainView = nil
		self.mainViewController = nil
		self.mainViewPresenter = nil
    }

    func testModuleIsNotNil() throws {
		XCTAssertNotNil(self.mainView, "view isn't nil")
		XCTAssertNotNil(self.mainViewController, "view isn't nil")
		XCTAssertNotNil(self.mainViewPresenter, "view isn't nil")
    }
	
	func testPresenter() {
		self.mainView.reloadTable()
		self.mainViewController.presenter?.actionTapRow()
		self.mainViewController.presenter?.actionDeleteRow()
		self.mainViewController.presenter?.actionAddButton()
		self.mainViewController.presenter?.actionLeftSwipe()
		self.mainViewController.presenter?.viewDidLoad()
		self.mainViewController.presenter?.notificationCame()
		
		XCTAssert(self.mainViewPresenter.recipeListGetResult, "recipeList doesn't get")
		XCTAssert(self.mainViewPresenter.actionTapRowResult, "actionTapRow didn't act")
		XCTAssert(self.mainViewPresenter.actionDeleteRowResult, "actionDeleteRow didn't act")
		XCTAssert(self.mainViewPresenter.actionAddButtonResult, "actionAddButton didn't act")
		XCTAssert(self.mainViewPresenter.actionLeftSwipeResult, "actionLeftSwipe didn't act")
		XCTAssert(self.mainViewPresenter.viewDidLoadResult, "viewDidLoad didn't act")
		XCTAssert(self.mainViewPresenter.notificationCameResult, "notificationCame didn't act")
	}
}
