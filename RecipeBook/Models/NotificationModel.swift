//
//  NotificationModel.swift
//  FinalWork
//
//  Created by Боровик Василий on 19.12.2020.
//
import Foundation

enum NotificationModel {
	static let recipeUpdated = Notification.Name(rawValue: "RecipeHasBeenUpdated")
	static let ingredientsUpdated = Notification.Name(rawValue: "IngredientsHasBeenUpdated")
}
