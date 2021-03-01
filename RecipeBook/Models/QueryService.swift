//
//  QueryService.swift
//  FinalWork
//
//  Created by Боровик Василий on 13.12.2020.
//

import CoreData
import UIKit

protocol IQueryService {
	func changeRecipe(content: RecipeContent)
	func changeIngredient(content: IngredientContent)
	func fetchRequestRecipesAt(id: UUID?) -> [Recipe]?
	func fetchRequestIngredientsAt(recipeID: UUID) -> [Ingredient]?
	func fetchRequestSelectedRecipes() -> [Recipe]?
	func addRecipe(info: RecipeContent)
	func addIngredient(info: IngredientContent, recipeID: UUID)
	func removeRecipeAt(id: UUID)
	func removeIngredientAt(id: UUID)
}

struct RecipeContent {
	var id: UUID?
	var name: String?
	var definition: String?
	var image: UIImage?
	var isSelected: Bool?
}

struct IngredientContent {
	var id: UUID?
	var name: String?
	var isMarked: Bool?
}

final class QueryService {
	lazy var persistContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "FinalWork")
		container.loadPersistentStores{ (storeDescription, error) in
			if let error = error {
				assertionFailure(error.localizedDescription)
			}
		}
		return container
	}()
	
	lazy var context: NSManagedObjectContext = {
		let context  = self.persistContainer.viewContext
		return context
	}()
}

private extension QueryService {
	func saveContext() {
		if self.context.hasChanges {
			do {
				try self.context.save()
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
	}
}

// MARK: IQueryService

extension QueryService: IQueryService {
	func fetchRequestSelectedRecipes() -> [Recipe]? {
		var recipe = [Recipe]()
		let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
		
		let predicate = NSPredicate(format: "isSelected == true", true as CVarArg )
		fetchRequest.predicate = predicate
		
		do {
			recipe = try self.context.fetch(fetchRequest)
		} catch {
			assertionFailure(error.localizedDescription)
			return nil
		}
		
		return recipe
	}
	
	func changeIngredient(content: IngredientContent) {
		if let name = content.name,
		   name != "",
		   let id = content.id {
			
			let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
			let predicate = NSPredicate(format: "id == %@", id as CVarArg)
			fetchRequest.predicate = predicate
			
			do {
				let ingredient = try self.context.fetch(fetchRequest)
				ingredient.first?.name = name
				ingredient.first?.isMarked = content.isMarked ?? false
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
		
		self.saveContext()
	}
	
	func changeRecipe(content: RecipeContent) {
		if let name = content.name,
		   name != "",
		   let id = content.id {
			
			let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
			let predicate = NSPredicate(format: "id == %@", id as CVarArg )
			fetchRequest.predicate = predicate
			
			do {
				let recipes = try self.context.fetch(fetchRequest)
				recipes.first?.name = name
				recipes.first?.definition = content.definition
				recipes.first?.image = content.image?.pngData()
				recipes.first?.isSelected = content.isSelected ?? false
			} catch {
				assertionFailure(error.localizedDescription)
			}
		}
		
		self.saveContext()
	}
	
	func removeRecipeAt(id: UUID) {
		let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
		let predicate = NSPredicate(format: "id == %@", id as CVarArg )
		fetchRequest.predicate = predicate
		
		do {
			let recipes = try self.context.fetch(fetchRequest)
			for recipe in recipes {
				self.context.delete(recipe)
			}
		} catch {
			assertionFailure(error.localizedDescription)
		}
		
		self.saveContext()
	}
	
	func removeIngredientAt(id: UUID) {
		let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
		let predicate = NSPredicate(format: "id == %@", id as CVarArg)
		fetchRequest.predicate = predicate
		
		do {
			let ingredients = try self.context.fetch(fetchRequest)
			for ingredient in ingredients {
				self.context.delete(ingredient)
			}
		} catch {
			assertionFailure(error.localizedDescription)
		}
		
		self.saveContext()
	}
	
	func fetchRequestRecipesAt(id: UUID?) -> [Recipe]? {
		var recipe = [Recipe]()
		let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
		
		if let id = id {
			let predicate = NSPredicate(format: "id == %@", id as CVarArg )
			fetchRequest.predicate = predicate
		}
		
		do {
			recipe = try self.context.fetch(fetchRequest)
		} catch let error as NSError {
			assertionFailure(error.localizedDescription)
			return nil
		}
		
		return recipe
	}
	
	func fetchRequestIngredientsAt(recipeID: UUID) -> [Ingredient]? {
		var ingredients = [Ingredient]()
		let fetchRequest: NSFetchRequest<Ingredient> = Ingredient.fetchRequest()
		
		let predicate = NSPredicate(format: "recipe.id == %@", recipeID as CVarArg)
		fetchRequest.predicate = predicate

		do {
			ingredients = try self.context.fetch(fetchRequest)
		} catch {
			assertionFailure(error.localizedDescription)
			return nil
		}
		
		return ingredients
	}
	
	func addRecipe(info: RecipeContent) {
		guard info.name != "",
			  let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: self.context)
		else {
			assertionFailure("Entity without name")
			return
		}
		
		let recipe = Recipe(entity: entity, insertInto: self.context)
		recipe.name = info.name
		recipe.definition = info.definition
		recipe.image = info.image?.pngData()
		recipe.id = info.id ?? UUID()
		
		self.saveContext()
	}
	
	func addIngredient(info: IngredientContent, recipeID: UUID) {
		guard info.name != "",
			  let entity = NSEntityDescription.entity(forEntityName: "Ingredient", in: self.context)
		else {
			assertionFailure("Entity without name")
			return
		}
		
		let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
		let predicate = NSPredicate(format: "id == %@", recipeID as CVarArg)
		fetchRequest.predicate = predicate
		
		do {
			let recipes = try self.context.fetch(fetchRequest)
			let ingredientObject = Ingredient(entity: entity, insertInto: self.context)
			
			ingredientObject.id = UUID()
			ingredientObject.name = info.name
			recipes.first?.addToIngredients(ingredientObject)
			
			self.saveContext()
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}
}


