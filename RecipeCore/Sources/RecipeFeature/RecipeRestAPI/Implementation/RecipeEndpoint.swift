import Foundation

extension RecipeEndpoint {
    var urlStr: String {
        switch self {
        case .valid:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
        case .malformed:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
        case .empty:
            return "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
        }
    }
}
