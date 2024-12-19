import Foundation

extension FileManager {
    static var directoryPath: URL {
        get {
            FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("RecipeImages")
        }
        set {}
    }
}
