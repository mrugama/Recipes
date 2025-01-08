import Foundation

public protocol Storage
where Self: Sendable,
      Self: Actor {
    func save(_ imageID: String, data: Data) async throws
    func getImageData(_ imageID: String) async throws -> Data?
    func clearCachedDirectory() async throws
    
    func getHash(from data: Data) async throws -> String
    func getLocalHash() async -> String?
    func shouldFetchOnline(remoteHash: String) async -> Bool
}

public protocol StorageService where Self: Sendable {
    func provideStorage() -> any Storage
}

public struct ConcreteStorageService: StorageService {
    public func provideStorage() -> any Storage {
        ConcreteStorage()
    }
    
    public init() {}
}
