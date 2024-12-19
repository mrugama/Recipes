import Foundation

public protocol DataLoader where Self: Sendable {
    func load(urlStr: String) async throws -> Data
}

public protocol DataLoaderService {
    func provideDataLoader() -> any DataLoader
}

public struct ConcreteDataLoaderService: DataLoaderService {
    public func provideDataLoader() -> any DataLoader {
        ConcreteDataLoader()
    }
    
    public init () {}
}
