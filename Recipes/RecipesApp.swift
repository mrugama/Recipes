//
//  RecipesApp.swift
//  Recipes
//
//  Created by Marlon Rugama on 12/17/24.
//

import Networking
import RecipeDomain
import RecipeRestAPI
import RecipeUI
import Storage
import SwiftUI

@main
struct RecipesApp: App {
    var viewModelService: RecipeViewModelService = Self.provideViewModelService()
    
    var body: some Scene {
        WindowGroup {
            ViewProvider.recipePage(
                viewModelService: viewModelService
            )
        }
    }
}


// MARK: - Setup service dependencies
extension RecipesApp {
    fileprivate static func provideDataLoaderService() -> DataLoaderService {
        ConcreteDataLoaderService()
    }
    
    fileprivate static func provideStorageService() -> StorageService {
        ConcreteStorageService()
    }
    
    fileprivate static func provideRestAPIService() -> RecipeRestAPIService {
        ConcreteRecipeRestAPIService(
            dataLoaderService: provideDataLoaderService(),
            storageService: provideStorageService()
        )
    }
    
    fileprivate static func provideViewModelService() -> RecipeViewModelService {
        .init(recipeRestAPIService: provideRestAPIService())
    }
}
