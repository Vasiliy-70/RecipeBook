//
//  IngredientsViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol IIngredientsViewController: class {
	func updateData()
}

protocol IIngredientsViewTableController: class {
	var cellId: String { get }
	var delegate: UITableViewDelegate { get }
	var dataSource: UITableViewDataSource { get }
}

final class IngredientsViewController: UIViewController {
	var presenter: IIngredientsViewPresenter?
	private var ingredientsList: [String]?
	private var cellIdentifier = "mainViewCell"
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = UITabBarItem(title: "Ингредиенты", image: ImagesStore.ingredientsIcon, selectedImage: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		self.configureSwipeRecognizer()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.presenter?.viewWillAppear()
		self.configureTabBarController()
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCame), name: NotificationModel.ingredientsUpdated, object: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: NotificationModel.ingredientsUpdated, object: nil)
	}
	
	override func loadView() {
		self.view = IngredientsView(tableController: self)
	}
}

private extension IngredientsViewController {
	func configureTabBarController() {
		self.tabBarController?.navigationItem.title = "Ингредиенты"
		
		self.tabBarController?.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.tabBarEditButtonAction))
		]
	}
}

// MARK: Action

private extension IngredientsViewController {
	@objc func tabBarEditButtonAction() {
		self.presenter?.actionEditButtonTabBar()
	}
	
	@objc func notificationCame() {
		self.presenter?.notificationCame()
	}
}

// MARK: UITableViewDelegate

extension IngredientsViewController: UITableViewDelegate {
	
}

// MARK: UITableViewDataSource

extension IngredientsViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.ingredientsList.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
		cell.textLabel?.text = self.presenter?.ingredientsList[indexPath.row]
		return cell
	}
}

// MARK: IIngredientsViewController

extension IngredientsViewController: IIngredientsViewController {
	func updateData() {
		self.ingredientsList = self.presenter?.ingredientsList
		let view = self.view as? IIngredientsView
		view?.reloadTable()
	}
}

// MARK: IIngredientsViewTableController

extension IngredientsViewController: IIngredientsViewTableController {
	var cellId: String {
		self.cellIdentifier
	}
	
	var delegate: UITableViewDelegate {
		self
	}
	
	var dataSource: UITableViewDataSource {
		self
	}
}


// MARK: SwipeRecognizer

private extension IngredientsViewController {
	func configureSwipeRecognizer() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
		swipeRecognizer.direction = .right
		self.view.addGestureRecognizer(swipeRecognizer)
	}
	
	@objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		self.presenter?.actionRightSwipe()
	}
}
