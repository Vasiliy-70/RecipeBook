//
//  RecipeViewController.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol IRecipeViewController: class {
	func updateData()
	func showAlert(message: String)
}

final class RecipeViewController: UIViewController {
	var presenter: IRecipeViewPresenter?
	private var recipeInfo = RecipeContent()
	private var cartButton = UIBarButtonItem()
	private var editButton = UIBarButtonItem()
	private var alertAddedToCard = UIAlertController()
	
	public init() {
		super.init(nibName: nil, bundle: nil)
		
		self.tabBarItem = UITabBarItem(title: "Описание", image: ImagesStore.listIcon, selectedImage: nil)
		self.configureAlert()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.configureSwipeRecognizer()
		self.configureAlert()
		self.presenter?.viewWillDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.configureTabBarController()
		NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCame), name: NotificationModel.recipeUpdated, object: nil)
	}

	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self, name: NotificationModel.recipeUpdated, object: nil)
	}
	
	override func loadView() {
		self.view = RecipeView()
	}
}

private extension RecipeViewController {
	func configureAlert() {
		let alertAddedToCard = UIAlertController(title: "", message: "", preferredStyle: .alert)
		
		let applyAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
		
		alertAddedToCard.addAction(applyAction)
		self.alertAddedToCard = alertAddedToCard
	}
	
	func configureTabBarController() {
		self.tabBarController?.navigationItem.title = "Просмотр"

		self.cartButton = UIBarButtonItem(image: ImagesStore.cartIcon, style: .plain, target: self, action: #selector(self.tabBarCartButtonAction))
		self.updateCarIcon()
		
		self.editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.tabBarEditButtonAction))

		self.tabBarController?.navigationItem.rightBarButtonItems = [self.editButton, self.cartButton]
	}
	
	func updateCarIcon() {
		self.cartButton.image = recipeInfo.isSelected ?? false ?
			ImagesStore.isSelectedIcon : ImagesStore.cartIcon
	}
}

// MARK: IRecipeViewController

extension RecipeViewController: IRecipeViewController {
	func showAlert(message: String) {
		self.alertAddedToCard.message = message
		self.present(alertAddedToCard, animated: true, completion: nil)
	}
	
	func updateData() {
		if let recipe = self.presenter?.recipe {
			self.recipeInfo = recipe
		}
		(self.view as? IRecipeView)?.showRecipe(info: self.recipeInfo)
		self.updateCarIcon()
	}
}

// MARK: SwipeRecognizer

private extension RecipeViewController {
	func configureSwipeRecognizer() {
		let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
		swipeRecognizer.direction = .left
		self.view.addGestureRecognizer(swipeRecognizer)
	}

	@objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
		self.presenter?.actionLeftSwipe()
	}
}

// MARK: Action

private extension RecipeViewController {
	@objc func tabBarCartButtonAction() {
		self.updateCarIcon()
		self.presenter?.actionCartButtonTabBar()
	}
	
	@objc func tabBarEditButtonAction() {
		self.presenter?.actionEditButtonTabBar()
	}
	
	@objc func notificationCame() {
		self.presenter?.notificationCame()
	}
}
