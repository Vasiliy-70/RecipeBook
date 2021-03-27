//
//  RecipeEditView.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import UIKit

protocol IRecipeEditView: class {
	func getRecipeInfo() ->  RecipeContent
	func showRecipe(info: RecipeContent)
}

final class RecipeEditView: UIView {
	private weak var viewController: IRecipeEditViewActionHandler?
	
	private var scrollView = UIScrollView()
	private var dishImage = UIImageView()
	private var nameField = UITextField()
	private var nameLabel = UILabel()
	private var descriptionField = UITextView()
	private var descriptionLabel = UILabel()
	private var descriptionView = UIView()
	
	private var dynamicConstraints = [NSLayoutConstraint]()

	private enum Constraints {
		static let textFieldsOffset: CGFloat = 10
		static let labelsOffset: CGFloat = 10
		static let imageOffset: CGFloat = 10
		
		static let descriptionFieldHeight: CGFloat = 150
		static let imageHeight: CGFloat = 200
		static let imageWidth: CGFloat = 200
	}
	
	private enum Constants {
		static let nameFieldCornerRadius: CGFloat = 4
		
		static let dishImageBorderWidth: CGFloat = 1
		static let dishImageCornerRadius = Constraints.imageWidth / 2
		static let descriptionFieldCornerRadius: CGFloat = 4
	}
	
	init(viewController: IRecipeEditViewActionHandler) {
		self.viewController = viewController
		super.init(frame: .zero)
		
		self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		self.setupViewAppearance()
		self.setupViewConstraints()
		self.hideKeyboardWhenTappedAround()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: setupViewAppearance

private extension RecipeEditView {
	func setupViewAppearance() {
		self.setupImagesView()
		self.setupLabelsView()
		self.setupTextFieldsView()
	}
	
	func setupImagesView() {
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapOnImage))
		self.dishImage.isUserInteractionEnabled = true
		self.dishImage.contentMode = .scaleToFill
		self.dishImage.layer.cornerRadius = Constants.dishImageCornerRadius
		self.dishImage.layer.borderWidth = Constants.dishImageBorderWidth
		self.dishImage.clipsToBounds = true
		self.dishImage.addGestureRecognizer(tapGestureRecognizer)
	}
	
	func setupLabelsView() {
		self.nameLabel.text = "Название"
		self.descriptionLabel.text = "Описание"
	}
	
	func setupTextFieldsView() {
		self.nameField.layer.borderWidth = 1
		self.nameField.layer.cornerRadius = Constants.nameFieldCornerRadius
		self.nameField.layer.borderColor = UIColor.lightGray.cgColor
		
		self.descriptionField.automaticallyAdjustsScrollIndicatorInsets = false
		self.descriptionField.isSelectable = true
		self.descriptionField.isEditable = true
		self.descriptionField.layer.cornerRadius = Constants.descriptionFieldCornerRadius
		self.descriptionField.layer.borderWidth = 1
		self.descriptionField.layer.borderColor = UIColor.lightGray.cgColor
	}
}

// MARK: setupViewConstraints

private extension RecipeEditView {
	func setupViewConstraints() {
		self.setupScrollViewConstraints()
		self.setupImagesAreaConstraints()
		self.setupNamesAreaConstraints()
		self.setupDescriptionAreaConstraints()
		self.setupNotification()
	}
	
	func setupScrollViewConstraints() {
		self.addSubview(self.scrollView)
		self.scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.scrollView.topAnchor.constraint(equalTo:
													self.safeAreaLayoutGuide.topAnchor),
			self.scrollView.leadingAnchor.constraint(equalTo:
														self.safeAreaLayoutGuide.leadingAnchor),
			self.scrollView.trailingAnchor.constraint(equalTo:
														self.safeAreaLayoutGuide.trailingAnchor)
		])
		
		self.dynamicConstraints.append(			self.scrollView.bottomAnchor.constraint(equalTo:
																							self.safeAreaLayoutGuide.bottomAnchor))
		NSLayoutConstraint.activate(self.dynamicConstraints)
	}
	
	func setupImagesAreaConstraints() {
		self.scrollView.addSubview(self.dishImage)
		self.dishImage.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.dishImage.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Constraints.imageOffset),
			self.dishImage.heightAnchor.constraint(equalToConstant: Constraints.imageHeight),
			self.dishImage.widthAnchor.constraint(equalToConstant: Constraints.imageWidth),
			self.dishImage.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])
	}
	
	func setupNamesAreaConstraints() {
		self.nameField.delegate = self
		
		self.scrollView.addSubview(self.nameLabel)
		self.scrollView.addSubview(self.nameField)
	
		self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
		self.nameField.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.nameLabel.topAnchor.constraint(equalTo: self.dishImage.bottomAnchor, constant: Constraints.labelsOffset),
			self.nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.labelsOffset),
			self.nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.labelsOffset)
		])
		
		NSLayoutConstraint.activate([
			self.nameField.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor),
			self.nameField.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
			self.nameField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.textFieldsOffset)
		])
	}
	
	func setupDescriptionAreaConstraints() {
		self.descriptionField.delegate = self
		
		self.scrollView.addSubview(self.descriptionView)
		self.descriptionView.addSubview(self.descriptionLabel)
		self.descriptionView.addSubview(self.descriptionField)
		
		self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
		self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		self.descriptionField.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			self.descriptionView.topAnchor.constraint(equalTo: self.nameField.bottomAnchor, constant: Constraints.labelsOffset),
			self.descriptionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: Constraints.labelsOffset),
			self.descriptionView.trailingAnchor.constraint(lessThanOrEqualTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -Constraints.labelsOffset),
			self.descriptionView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
		])
		
		
		NSLayoutConstraint.activate([
			self.descriptionLabel.topAnchor.constraint(equalTo: self.descriptionView.topAnchor),
			self.descriptionLabel.leadingAnchor.constraint(equalTo: self.descriptionView.leadingAnchor),
			self.descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.descriptionView.trailingAnchor, constant: -Constraints.labelsOffset)
		])
		
		NSLayoutConstraint.activate([
			self.descriptionField.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor),
			self.descriptionField.leadingAnchor.constraint(equalTo: self.descriptionLabel.leadingAnchor),
			self.descriptionField.trailingAnchor.constraint(equalTo:
				self.descriptionView.trailingAnchor),
			self.descriptionField.heightAnchor.constraint(equalToConstant: Constraints.descriptionFieldHeight),
			self.descriptionField.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor)
			
		])
	}
}

// MARK: IRecipeEditView

extension RecipeEditView: IRecipeEditView {
	func getRecipeInfo() ->  RecipeContent {
		var info =  RecipeContent()
		info.name = self.nameField.text
		info.definition = self.descriptionField.text
		info.image = self.dishImage.image
		
		return info
	}
	
	func showRecipe(info: RecipeContent) {
		self.nameField.text = info.name ?? ""
		self.descriptionField.text = info.definition ?? ""
		self.dishImage.image = info.image ?? ImagesStore.empty
	}
}

// MARK: Action

private extension RecipeEditView {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
		tap.cancelsTouchesInView = false
		self.addGestureRecognizer(tap)
	}
	
	@objc func hideKeyboard() {
		self.endEditing(true)
	}
	
	@objc func tapOnImage() {
		self.viewController?.tapOnImage()
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
		
		NSLayoutConstraint.deactivate(self.dynamicConstraints)
		self.dynamicConstraints.removeAll()
		self.dynamicConstraints.append(contentsOf: [
			self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -keyboardSize.height)
		])
		
		NSLayoutConstraint.activate(self.dynamicConstraints)
		self.layoutIfNeeded()
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		NSLayoutConstraint.deactivate(self.dynamicConstraints)
		self.dynamicConstraints.removeAll()
		self.dynamicConstraints.append(contentsOf: [
			self.scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
		])
		
		NSLayoutConstraint.activate(self.dynamicConstraints)
		self.layoutIfNeeded()
	}
}

// MARK: Notification

private extension RecipeEditView {
	func setupNotification() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
}

// MARK: UITextFieldDelegate

extension RecipeEditView: UITextFieldDelegate {
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if self.traitCollection.verticalSizeClass == .compact {
			let point = self.nameLabel.frame.origin
			self.scrollView.setContentOffset(point, animated: true)
		}
	}
}

// MARK: UITextViewDelegate

extension RecipeEditView: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if self.traitCollection.verticalSizeClass == .compact {
			let point = self.descriptionView.frame.origin
			self.scrollView.setContentOffset(point, animated: true)
		}
	}
}
