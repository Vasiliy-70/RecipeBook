//
//  RecipeView.swift
//  FinalWork
//
//  Created by Боровик Василий on 15.12.2020.
//

import UIKit

protocol IRecipeView: class {
	func showRecipe(info: RecipeContent)
}

final class RecipeView: UIView {
	private var scrollView = UIScrollView()
	private var recipeImage = UIImageView()
	private var nameLabel =  UILabel()
	private var descriptionLabel = UILabel()
	
	private enum Constraints {
		static let recipeImageOffset: CGFloat = 0
		static let recipeImageHeight: CGFloat = 300
		
		static let labelsOffset: CGFloat = 10
		static let nameLabelHeight: CGFloat = 50
		static let descriptionLabelHeight: CGFloat = 150
	}
	
	init() {
		super.init(frame: .zero)
	
		self.setupViewAppearance()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension RecipeView {
	func setupViewAppearance() {
		self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.setupScrollView()
		self.setupImageView()
		self.setupLabelView()
		self.setupDescriptionLabel()
	}
	
	func setupScrollView() {
		self.addSubview(self.scrollView)
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			self.scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
			self.scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
			self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
		])
		
	}
	
	func setupImageView() {
		self.recipeImage.contentMode = .scaleToFill
		
		self.scrollView.addSubview(self.recipeImage)
		self.recipeImage.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.recipeImage.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Constraints.recipeImageOffset),
			self.recipeImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.recipeImageOffset),
			self.recipeImage.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.recipeImageOffset),
			self.recipeImage.heightAnchor.constraint(equalToConstant: Constraints.recipeImageHeight)
		])
	}
	
	func setupLabelView() {
		self.nameLabel.backgroundColor = .black
		self.nameLabel.textColor = .white
		self.nameLabel.textAlignment = .left
		self.nameLabel.alpha = 0.4
		
		self.recipeImage.addSubview(self.nameLabel)
		self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.nameLabel.bottomAnchor.constraint(equalTo: self.recipeImage.bottomAnchor),
			self.nameLabel.leadingAnchor.constraint(equalTo: self.recipeImage.leadingAnchor),
			self.nameLabel.trailingAnchor.constraint(equalTo: self.recipeImage.trailingAnchor),
			self.nameLabel.heightAnchor.constraint(equalToConstant: Constraints.nameLabelHeight)
		])
	}
	
	func setupDescriptionLabel() {
		self.descriptionLabel.numberOfLines = 0
		self.descriptionLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.descriptionLabel.textAlignment = .left
		
		self.scrollView.addSubview(self.descriptionLabel)
		self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.descriptionLabel.topAnchor.constraint(equalTo: self.recipeImage.bottomAnchor, constant: Constraints.labelsOffset),
			self.descriptionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.labelsOffset),
			self.descriptionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.labelsOffset),
			self.descriptionLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
		
		])
	}
}

// MARK: IRecipeView

extension RecipeView: IRecipeView {
	func showRecipe(info: RecipeContent) {
		self.nameLabel.text = info.name
		self.descriptionLabel.text = info.definition
		self.recipeImage.image = info.image ?? UIImage()
	}
}
