//
//  RecipeEditViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

protocol IRecipeEditViewController: class {
	var recipe: RecipeContent { get }
	func updateData()
	func showAlertIngredients()
	func showAlertError(message: String)
}

protocol IRecipeEditViewActionHandler: class {
	func tapOnImage()
}

final class RecipeEditViewController: UIViewController {
	var presenter: IRecipeEditViewPresenter?
	private var alertIngredients = UIAlertController()
	private var alertError = UIAlertController()
	private var modalMode = false
	
	private var recipeInfo = RecipeContent() {
		willSet {
			self.navigationItem.title = newValue.id != nil ?
				"Редактор" : "Создание рецепта"
		}
	}

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
		self.presenter?.viewDidLoad()
	}
	
	override func loadView() {
		self.view = RecipeEditView(viewController: self)
	}
}

private extension RecipeEditViewController {
	func configureNavigationBar() {
		if modalMode {
			self.navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.actionCancelButton))]
		}
		self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.actionSaveButton))]
	}
}

private extension RecipeEditViewController {
	func configureAlert() {
		let alertError = UIAlertController(title: "Ошибка", message: "Поле \"Название\" не может быть пустым", preferredStyle: .alert)
		
		let applyAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
		
		alertError.addAction(applyAction)

		let alertIngredients = UIAlertController(title: "Готово!", message: "Хотите ли вы добавить ингредиенты?", preferredStyle: .alert)
		
		self.alertError = alertError
		
		let addIngredients = UIAlertAction(title: "Да", style: .default, handler: {
			[weak self] _ in
			self?.presenter?.actionAlertIngredients()
		})
		
		let cancel = UIAlertAction(title: "Нет", style: .cancel, handler: {
			[weak self] _ in
			self?.presenter?.cancelAlertIngredients()
		})
		
		alertIngredients.addAction(addIngredients)
		alertIngredients.addAction(cancel)
		self.alertIngredients = alertIngredients
	}
}

// MARK: IRecipeEditViewController

extension RecipeEditViewController: IRecipeEditViewController {
	func showAlertError(message: String) {
		self.alertError.message = message
		self.present(self.alertError, animated: true)
	}
	
	var recipe: RecipeContent {
		self.recipeInfo
	}
	
	func updateData() {
		if let recipe = self.presenter?.recipe {
			self.recipeInfo = recipe
			let view = self.view as? IRecipeEditView
			view?.showRecipe(info: self.recipeInfo)
		}
	}
	
	func showAlertIngredients() {
		self.present(self.alertIngredients, animated: true, completion: nil)
	}
}

// MARK: Action

private extension RecipeEditViewController {
	@objc func actionSaveButton() {
		if let view = self.view as? IRecipeEditView {
			self.recipeInfo.name = view.getRecipeInfo().name
			self.recipeInfo.definition = view.getRecipeInfo().definition
			self.recipeInfo.image = view.getRecipeInfo().image
			self.presenter?.actionSaveButton(modalMode: self.modalMode)
		}
	}
	
	@objc func actionCancelButton() {
		self.presenter?.actionCancelButton()
	}
	
	func presentImageViewPicker(sender: AnyObject) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = .photoLibrary
		imagePicker.allowsEditing = false
		
		self.present(imagePicker, animated: true, completion: nil)
	}
}

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RecipeEditViewController:  UIImagePickerControllerDelegate,
									 UINavigationControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController,
							   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			self.recipeInfo.image = image
			(self.view as? IRecipeEditView)?.showRecipe(info: self.recipeInfo)
			self.navigationController?.dismiss(animated: true, completion: nil)
		}
	}
}

// MARK: IRecipeEditViewActionHandler

extension RecipeEditViewController: IRecipeEditViewActionHandler {
	func tapOnImage() {
		self.presentImageViewPicker(sender: self)
	}
}
