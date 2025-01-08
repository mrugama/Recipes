import CryptoKit
import Foundation

actor ConcreteStorage: Storage {
    private lazy var path: URL = {
        FileManager
            .directoryPath
    }()
    
    func save(_ imageID: String, data: Data) async throws {
        let path = path.appendingPathComponent(imageID)
        try data.write(to: path)
    }
    
    func getImageData(_ imageID: String) async throws -> Data? {
        let path = path.appendingPathComponent(imageID)
        return try Data(contentsOf: path)
    }
    
    func clearCachedDirectory() async throws {
        try FileManager.default.removeItem(at: path)
    }
}

// MARK: - Verify response integrity
extension ConcreteStorage {
    private var userDefaults: UserDefaults {
        UserDefaults.init(suiteName: "ResponseChecksum") ?? UserDefaults.standard
    }
    private var localHash: String? {
        get {
            userDefaults.string(forKey: "localHash")
        }
        set {
            userDefaults.set(newValue, forKey: "localHash")
        }
    }
    
    func getHash(from data: Data) async throws -> String {
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    func getLocalHash() -> String? {
        localHash
    }
    
    func shouldFetchOnline(remoteHash: String) async -> Bool {
        guard let hash = localHash else { return true }
        let shouldFetch = !(remoteHash == hash)
        if shouldFetch {
            localHash = remoteHash
        }
        return shouldFetch
    }
}
