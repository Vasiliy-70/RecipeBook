//
//  MainView.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

protocol IMainView {
	func reloadTable()
	func textInCellForRow(at indexPath: IndexPath) -> String?
}

class MainView: UIView {
	private let recipesTable = UITableView()
	private weak var tableController: IMainViewTableController?
	
	private enum Constraints {
		static let recipesTableOffset: CGFloat = 10
		static let recipesTableMaxWidth: CGFloat = 550
	}
	
	init(tableController: IMainViewTableController) {
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

private extension MainView {
	func configureTable() {
		self.recipesTable.register(MainViewTableCell.self, forCellReuseIdentifier: self.tableController?.cellId ?? "")
		
		self.recipesTable.delegate = self.tableController?.delegate
		self.recipesTable.dataSource = self.tableController?.dataSource
	}
	
	func setupTableAppearance() {
		self.recipesTable.backgroundColor = .white
		self.addSubview(self.recipesTable)
		self.recipesTable.translatesAutoresizingMaskIntoConstraints = false
		
		let widthConstraint = self.recipesTable.widthAnchor.constraint(lessThanOrEqualToConstant: Constraints.recipesTableMaxWidth)
		widthConstraint.priority = UILayoutPriority(rawValue: 1000)
		
		let leadingConstraint = self.recipesTable.leadingAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.recipesTableOffset)
		leadingConstraint.priority = UILayoutPriority(rawValue: 750)
		
		let trailingConstraint = self.recipesTable.trailingAnchor.constraint(greaterThanOrEqualTo:  self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.recipesTableOffset)
		trailingConstraint.priority = UILayoutPriority(rawValue: 750)
		
		
		NSLayoutConstraint.activate([
			self.recipesTable.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			self.recipesTable.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Constraints.recipesTableOffset),
			leadingConstraint,
			widthConstraint,
			trailingConstraint,
			self.recipesTable.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -Constraints.recipesTableOffset),

		])
	}
}

// MARK: IMainView

extension MainView: IMainView {
	func reloadTable() {
		self.recipesTable.reloadData()
	}
	
	func textInCellForRow(at indexPath: IndexPath) -> String? {
		let cell = self.recipesTable.cellForRow(at: indexPath)
		return (cell as? IMainViewTableCell)?.title
	}
}

