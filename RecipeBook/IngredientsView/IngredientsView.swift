//
//  IngredientsView.swift
//  FinalWork
//
//  Created by Боровик Василий on 16.12.2020.
//

import UIKit

protocol IIngredientsView {
	func reloadTable()
	func textInCellForRow(at indexPath: IndexPath) -> String?
}

final class IngredientsView: UIView {
	private let ingredientsTable = UITableView()
	private weak var tableController: IIngredientsViewTableController?
	
	private enum Constraints {
		static let ingredientsTableOffset: CGFloat = 10
	}
	
	init(tableController: IIngredientsViewTableController) {
		self.tableController = tableController
		super.init(frame: .zero)
		
		self.backgroundColor = .white
		self.configureTable()
		self.setupTableAppearance()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension IngredientsView {
	func configureTable() {
		self.ingredientsTable.register(UITableViewCell.self, forCellReuseIdentifier: self.tableController?.cellId ?? "")
		
		self.ingredientsTable.delegate = self.tableController?.delegate
		self.ingredientsTable.dataSource = self.tableController?.dataSource
	}
	
	func setupTableAppearance() {
		self.ingredientsTable.backgroundColor = .white
		self.addSubview(self.ingredientsTable)
		self.ingredientsTable.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.ingredientsTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraints.ingredientsTableOffset),
			self.ingredientsTable.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.ingredientsTableOffset),
			self.ingredientsTable.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.ingredientsTableOffset),
			self.ingredientsTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.ingredientsTableOffset)
		])
	}
}

// MARK: IIngredientsView

extension IngredientsView: IIngredientsView {
	func reloadTable() {
		self.ingredientsTable.reloadData()
	}
	
	func textInCellForRow(at indexPath: IndexPath) -> String? {
		self.ingredientsTable.cellForRow(at: indexPath)?.textLabel?.text
	}
}

