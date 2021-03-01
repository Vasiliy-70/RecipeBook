//
//  FinalWorkUITest.swift
//  FinalWorkUITest
//
//  Created by Боровик Василий on 19.12.2020.
//

import XCTest

class FinalWorkUITest: XCTestCase {
	var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
		self.app.launch()
    }
	 
    func testShowCart() throws {
		let navigationBarMainView = app.navigationBars["Мои рецепты"]
		let navigationBarCartView = app.navigationBars["Список покупок"]
		let addButton =  navigationBarMainView.buttons["Add"]
		let tabBar = XCUIApplication().tabBars["Tab Bar"]
		let cartButton = tabBar.buttons["Список покупок"]
		let mainViewButton = tabBar.buttons["Каталог рецептов"]
		let refreshButton = navigationBarCartView.buttons["Refresh"]
		let removeButton = navigationBarCartView.buttons["Delete"]
		let cancelButton = app.alerts["Внимание"].scrollViews.otherElements.buttons["Нет"]
		
		XCTAssertTrue(navigationBarMainView.exists)
		XCTAssertTrue(tabBar.exists)
		XCTAssertTrue(addButton.exists)
		XCTAssertTrue(mainViewButton.exists)
		XCTAssertTrue(cartButton.exists)
		cartButton.tap()
		XCTAssertFalse(navigationBarMainView.exists)
		XCTAssertFalse(addButton.exists)
		XCTAssertTrue(navigationBarCartView.exists)
		XCTAssertTrue(refreshButton.exists)
		XCTAssertTrue(removeButton.exists)
		removeButton.tap()
		XCTAssertTrue(cancelButton.exists)
		mainViewButton.tap()
		XCTAssertFalse(navigationBarCartView.exists)
		XCTAssertFalse(refreshButton.exists)
		XCTAssertFalse(removeButton.exists)
		XCTAssertTrue(navigationBarMainView.exists)
		XCTAssertTrue(tabBar.exists)
		XCTAssertTrue(addButton.exists)
    }
}
