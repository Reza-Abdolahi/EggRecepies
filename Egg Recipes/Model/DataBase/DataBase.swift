//
//  DataBase.swift
//  First Task
//
//  Created by Reza Abdolahi on 6/13/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    static let sharedInstance = DataBaseManager()
    private var database: Realm
    public var recipesArray: [RecipeObj] = []
    
    private init() {
        database = try! Realm()
        recipesArray = loadRecipesArray()
    }

    func loadRecipesArray() -> [RecipeObj] {

        // Not first launch -> getting recipes array as [RecepiesObj]
        if Array(database.objects(RecipeObj.self)).count != 0 {
        } else {
         // First launch -> load recipes from JSON -> Save all as [RecipeObj] in database
            loadJSONAndSaveAllRecipesInDatabase()
        }
         return database.objects(RecipeObj.self).compactMap({ $0 })
    }
    
     func loadJSONAndSaveAllRecipesInDatabase() {
        if let jsonRecipesArray: [Recipe] = loadLocalJSON(){
            for recipe in jsonRecipesArray {
                let recipeObj = RecipeObj()
                recipeObj.recipeStruct = recipe
                recipeObj.id = UUID().uuidString
                try! database.write {
                    database.add(recipeObj)
                }
            }
        } else {
            print("Problem Loading the JSON file")
        }
    }
    
    func loadLocalJSON() -> [Recipe]? {
        if let jsonUrl = Bundle.main.url(forResource: "recipes", withExtension: "json") {
            do {
                let data = try Data(contentsOf: jsonUrl)
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(Recipes.self, from: data)
                return result
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    func updateRecipesArray() {
        recipesArray = database.objects(RecipeObj.self).compactMap({ $0 })
    }
    
    func addRecipeToDatabase(recipe:Recipe) {
        let newRecipeObj = RecipeObj()
        newRecipeObj.recipeStruct = recipe
        newRecipeObj.id = UUID().uuidString
        try! database.write {
            database.add(newRecipeObj)
        }
        updateRecipesArray()
    }
    
    func deleteRecipeFromDatabase(recipeID: String) {
        let recipeToDelete = database.object(ofType: RecipeObj.self, forPrimaryKey: recipeID)
        if let recipeToDelete = recipeToDelete {
            try! database.write {
                database.delete(recipeToDelete)
            }
            print("Delete Successful")
        }else{
            print("Error: delete unsuccessful")
        }
        updateRecipesArray()
    }
    
    func updateRecipe(recipe: Recipe, uuid: String) {
        let storedRecipe = database.object(ofType: RecipeObj.self, forPrimaryKey: uuid)
        
        if let storedRecipe = storedRecipe {
            try! database.write {
                storedRecipe.recipeStruct? = recipe
            }
        }
    }
    
    func updateVoteUpValue(forRecipeID uniqueID: String ,withValue value: Int) {
        let storedRecipe = database.object(ofType: RecipeObj.self, forPrimaryKey:uniqueID)
        if let storedRecipe = storedRecipe {
            try! database.write {
                storedRecipe.recipeStruct?.upvotes = value
            }
        }
     }
    
    func updateVoteDownValue(forRecipeID uniqueID: String ,withValue value: Int) {
        let storedRecipe = database.object(ofType: RecipeObj.self, forPrimaryKey: uniqueID)
        if let storedRecipe = storedRecipe {
            try! database.write {
                storedRecipe.recipeStruct?.downvotes = value
            }
        }
    }
    
}




