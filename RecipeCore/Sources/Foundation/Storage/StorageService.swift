import Foundation

public protocol Storage where Self: Sendable {
    func save(_ imageID: String, data: Data) throws
    func getImageData(_ imageID: String) throws -> Data?
    func clearCachedDirectory() throws
}

public protocol StorageService {
    func provideStorage() -> any Storage
}

public struct ConcreteStorageService: StorageService {
    public func provideStorage() -> any Storage {
        ConcreteStorage()
    }
    
    public init() {}
}
