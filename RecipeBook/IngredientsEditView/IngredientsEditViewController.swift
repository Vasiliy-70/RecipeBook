//
//  IngredientsEditViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 15.12.2020.
//

import UIKit

protocol IIngredientsEditViewController: class {
	func updateData()
	var selectedRow: Int? { get }
	func showAlertIngredients(title: String, message: String, textValue: String?)
}

protocol IIngredientEditViewTableController: class {
	var cellId: String { get }
	var delegate: UITableViewDelegate { get }
	var dataSource: UITableViewDataSource { get }
}

protocol IIngredientEditViewActionHandler: class {
	func tapOnApplyButton()
}

final class IngredientsEditViewController: UIViewController {
	var presenter: IIngredientsEditViewPresenter?
	private var editCellAlert = UIAlertController()
	
	private var ingredientList: [String]?
	private var currentRow: Int?
	private var cellIdentifier = "ingredientViewCell"
	private var modalMode = false
	
	public init(modalMode: Bool) {
		self.modalMode = modalMode
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.configureNavigationBar()
		self.configureAlert()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.presenter?.viewWillAppear()
	}
	
	override func loadView() {
		self.view = IngredientsEditView(tableController: self)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.post(name: NotificationModel.ingredientsUpdated, object: AnyObject.self)
	}
}

private extension IngredientsEditViewController {
	func configureNavigationBar() {
		self.navigationItem.rightBarButtonItems = [
			UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.actionAddButton))
		]
		
		if self.modalMode {
			self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.actionCancelButton))]
		}
		self.navigationItem.title = "Редактор"
	}
	
	func configureAlert() {
		let editCellAlert = UIAlertController(title: "Редактирование ингредиента", message: "Введите значение", preferredStyle: .alert)
		
		let applyChange = UIAlertAction(title: "Применить", style: .default, handler: {
			[weak self] _ in
			if let self = self,
			   let name = self.editCellAlert.textFields?.first?.text,
			   name != "" {
				self.presenter?.actionEditCellAlert(newName: name)
			} else {
				let alert = UIAlertController(title: "Ошибка", message: "Описание ингредиента не может быть пустым", preferredStyle: .alert)
				let applyAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
				
				alert.addAction(applyAction)
				self?.present(alert, animated: true, completion: nil)
			}
			self?.editCellAlert.textFields?.first?.text = ""
		})
		
		let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
		
		editCellAlert.addTextField(configurationHandler: nil)
		editCellAlert.addAction(applyChange)
		editCellAlert.addAction(cancel)
		self.editCellAlert = editCellAlert
	}
}

// MARK: UITableViewDelegate

extension IngredientsEditViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let view = self.view as? IngredientsEditView
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

extension IngredientsEditViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.presenter?.ingredientList.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
		cell.textLabel?.text = self.presenter?.ingredientList[indexPath.row]
		return cell
	}
}

// MARK: IIngredientsEditViewController

extension IngredientsEditViewController: IIngredientsEditViewController {
	func updateData() {
		self.ingredientList = self.presenter?.ingredientList
		let view = self.view as? IIngredientsEditView
		view?.reloadTable()
	}
	
	var selectedRow: Int? {
		self.currentRow
	}
	
	func showAlertIngredients(title: String, message: String, textValue: String?) {
		self.editCellAlert.title = title
		self.editCellAlert.message = message
		self.editCellAlert.textFields?.first?.text = textValue ?? ""
		self.present(self.editCellAlert, animated: true, completion: nil)
	}
}

// MARK: IIngredientEditViewTableController

extension IngredientsEditViewController: IIngredientEditViewTableController {
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

// MARK: IIngredientEditViewActionHandler

extension IngredientsEditViewController: IIngredientEditViewActionHandler {
	func tapOnApplyButton() {
		self.presenter?.actionApplyButton(modalMode: self.modalMode)
	}
}

// MARK: Action

private extension IngredientsEditViewController {
	@objc func actionAddButton() {
		self.presenter?.actionAddButton()
	}
	
	@objc func actionCancelButton() {
		self.presenter?.actionCancelButton()
	}
}
