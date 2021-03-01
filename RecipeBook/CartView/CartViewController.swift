//
//  CartViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol ICartViewController: class {
	func updateData()
	var selectedRow: Int? { get }
}

protocol ICartViewTableController: class {
	var cellId: String { get }
	var delegate: UITableViewDelegate { get }
	var dataSource: UITableViewDataSource { get }
}

final class CartViewController: UIViewController {
	var presenter: ICartViewPresenter?
	private var cellIdentifier = "mainViewCell"
	private var currentRow:  Int?
	private var alertClearTable = UIAlertController()
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "Список покупок",
									   image: ImagesStore.cartIcon, selectedImage: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureSwipeRecognizer()
		self.configureAlert()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.presenter?.viewWillAppear()
		self.configureTabBarController()
	}
	
	override func loadView() {
		self.view = CartView(tableController: self)
	}
}

private extension CartViewController {
	func configureAlert() {
		let alertClearTable = UIAlertController(title: "Внимание", message: "Очистить содержимое корзины?", preferredStyle: .alert)
		
		let applyAction = UIAlertAction(title: "Да", style: .default, handler: {
			[weak self] _ in
			self?.actionApplyAlertClearTable()
		})
		let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
		
		alertClearTable.addAction(applyAction)
		alertClearTable.addAction(cancelAction)
		self.alertClearTable = alertClearTable
	}
	
	func configureTabBarController() {
		self.tabBarController?.title = "Список покупок"
		
		self.tabBarController?.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.actionRefreshBarButton))
		]
		
		self.tabBarController?.navigationItem.leftBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(self.actionTrashButtonTabBar))
		]
	}
	
	func actionApplyAlertClearTable() {
		self.presenter?.actionTrashButtonTabBar()
	}
	
	@objc func actionRefreshBarButton() {
		self.presenter?.actionRefreshButtonTabBar()
	}
	
	@objc func actionTrashButtonTabBar() {
		if !(self.presenter?.ingredientsList.isEmpty ?? true) {
			self.present(self.alertClearTable, animated: true, completion: nil)
		}
	}
}

// MARK: UITableViewDelegate

extension CartViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.currentRow = indexPath.row
		self.presenter?.actionTapRow()
	}
}

// MARK: UITableViewDataSource

extension CartViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.ingredientsList.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
		
		if let ingredientsName = self.presenter?.ingredientsList[indexPath.row].name,
		   let isMarked = self.presenter?.ingredientsList[indexPath.row].isMarked {
			
			if isMarked {
				let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: ingredientsName)
				attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
				cell.textLabel?.attributedText = attributeString
			} else {
				cell.textLabel?.attributedText = nil
				cell.textLabel?.text = ingredientsName
			}
		}
		return cell
	}
}

// MARK: ICartViewController

extension CartViewController: ICartViewController {
	var selectedRow: Int? {
		self.currentRow
	}
	
	func updateData() {
		let view = self.view as? ICartView
		view?.reloadTable()
	}
}

// MARK: ICartViewTableController

extension CartViewController: ICartViewTableController {
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

private extension CartViewController {
	func configureSwipeRecognizer() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
		swipeRecognizer.direction = .right
		self.view.addGestureRecognizer(swipeRecognizer)
	}
	
	@objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		self.presenter?.actionRightSwipe()
	}
}
