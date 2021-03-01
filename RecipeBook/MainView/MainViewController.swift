//
//  MainViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

protocol IMainViewController: class {
	func updateData()
	var selectedRow: Int? { get }
}

protocol IMainViewTableController: class {
	var cellId: String { get }
	var delegate: UITableViewDelegate { get }
	var dataSource: UITableViewDataSource { get }
}

final class MainViewController: UIViewController {
	var presenter: IMainViewPresenter?
	private var currentRow: Int?
	private var cellIdentifier = "mainViewCell"

	public init() {
		super.init(nibName: nil, bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "Каталог рецептов", image: ImagesStore.catalogIcon, selectedImage: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureSwipeRecognizer()
		self.presenter?.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.configureTabBarController()
		NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCame), name: NotificationModel.recipeUpdated, object: nil)
	}
	
	override func loadView() {
		self.view = MainView(tableController: self)
		
	}
}

private extension MainViewController {
	func configureTabBarController() {
		self.tabBarController?.title = "Мои рецепты"
		
		self.tabBarController?.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.actionAddButton))
		]
		
		self.tabBarController?.navigationItem.leftBarButtonItems = []
	}
}

// MARK: UITableViewDelegate

extension MainViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let view = self.view as? IMainView
			if view?.textInCellForRow(at: indexPath) != nil {
				self.currentRow = indexPath.row
				self.presenter?.actionDeleteRow()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentRow = indexPath.row
		self.presenter?.actionTapRow()
	}
}

// MARK: UITableViewDataSource

extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.recipeList.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as? IMainViewTableCell else { assertionFailure("No tableCellView"); return UITableViewCell() }
		
		cell.mainImage = self.presenter?.recipeList[indexPath.row].image ?? (ImagesStore.empty ?? UIImage())
		cell.title = self.presenter?.recipeList[indexPath.row].name
		cell.cartIcon = self.presenter?.recipeList[indexPath.row].isSelected ?? false ? ImagesStore.isSelectedWhiteIcon : nil
		
		cell.updateContent()
		return cell as? UITableViewCell ?? UITableViewCell()
	}
}

// MARK: IMainViewController

extension MainViewController: IMainViewController {
	func updateData() {
		let view = self.view as? IMainView
		view?.reloadTable()
	}
	
	var selectedRow: Int? {
		self.currentRow
	}
}

// MARK: IMainViewTableController

extension MainViewController: IMainViewTableController {
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

// MARK: Action

private extension MainViewController {
	@objc func actionAddButton() {
		self.presenter?.actionAddButton()
	}
	
	@objc func notificationCame() {
		self.presenter?.notificationCame()
	}
}

// MARK: SwipeRecognizer

private extension MainViewController {
	func configureSwipeRecognizer() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
		swipeRecognizer.direction = .left
		self.view.addGestureRecognizer(swipeRecognizer)
	}

	@objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		self.presenter?.actionLeftSwipe()
	}
}
