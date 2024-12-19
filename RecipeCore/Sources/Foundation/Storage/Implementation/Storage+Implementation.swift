import Foundation

struct ConcreteStorage: Storage {    
    func save(_ imageID: String, data: Data) throws {
        let path = FileManager
            .directoryPath
            .appendingPathComponent(imageID)
        try? data.write(to: path)
    }
    
    func getImageData(_ imageID: String) throws -> Data? {
        let path = FileManager
            .directoryPath
            .appendingPathComponent(imageID)
        let data = try? Data(contentsOf: path)
        return data
    }
    
    func clearCachedDirectory() throws {
        let path = FileManager.directoryPath
        try FileManager.default.removeItem(at: path)
    }
}
