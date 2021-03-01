//
//  IngredientsEditView.swift
//  FinalWork
//
//  Created by Боровик Василий on 15.12.2020.
//

import UIKit

protocol IIngredientsEditView {
	func reloadTable()
	func textInCellForRow(at indexPath: IndexPath) -> String?
}

final class IngredientsEditView: UIView {
	private let ingredientsTable = UITableView()
	private let tableController: IIngredientEditViewTableController
	private var applyButton = UIButton()
	
	private enum Constraints {
		static let ingredientsTableOffset: CGFloat = 10
		
		static let applyButtonOffset: CGFloat = 10
		static let applyButtonHeight: CGFloat = 40
		static let applyButtonWidth: CGFloat = 100
	}
	
	init(tableController: IIngredientEditViewTableController) {
		self.tableController = tableController
		super.init(frame: .zero)
		
		self.setupViewSettings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension IngredientsEditView {
	func setupViewSettings() {
		self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		
		self.configureTable()
		self.configureButton()
		self.setupButtonConstraint()
		self.setupTableAppearance()
	}
	
	func configureTable() {
		self.ingredientsTable.register(UITableViewCell.self, forCellReuseIdentifier: self.tableController.cellId)
		self.ingredientsTable.delegate = self.tableController.delegate
		self.ingredientsTable.dataSource = self.tableController.dataSource
	}
	
	func configureButton() {
		self.applyButton.backgroundColor = .white
		self.applyButton.setTitle("Готово", for: .normal)
		self.applyButton.setTitleColor(.blue, for: .normal)
		self.applyButton.setTitleColor(.white, for: .highlighted)
		self.applyButton.addTarget(self, action: #selector(self.applyButtonAction), for: .touchUpInside)
	}
	
	func setupButtonConstraint() {
		self.addSubview(self.applyButton)
		self.applyButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.applyButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.applyButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.applyButtonOffset),
			self.applyButton.widthAnchor.constraint(equalToConstant: Constraints.applyButtonWidth),
			self.applyButton.heightAnchor.constraint(equalToConstant: Constraints.applyButtonHeight)
		])
	}
	
	func setupTableAppearance() {
		self.ingredientsTable.backgroundColor = .white
		self.addSubview(self.ingredientsTable)
		self.ingredientsTable.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.ingredientsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraints.ingredientsTableOffset),
			self.ingredientsTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.ingredientsTableOffset),
			self.ingredientsTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.ingredientsTableOffset),
			self.ingredientsTable.bottomAnchor.constraint(equalTo: self.applyButton.topAnchor, constant: -Constraints.ingredientsTableOffset)
		])
	}
}

// MARK: IIngredientsEditView

extension IngredientsEditView: IIngredientsEditView {
	func reloadTable() {
		self.ingredientsTable.reloadData()
	}
	
	func textInCellForRow(at indexPath: IndexPath) -> String? {
		self.ingredientsTable.cellForRow(at: indexPath)?.textLabel?.text
	}
}

// MARK: Action

private extension IngredientsEditView {
	@objc func applyButtonAction() {
		(self.tableController as? IIngredientEditViewActionHandler )?.tapOnApplyButton()
	}
}
