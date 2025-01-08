import XCTest
@testable import Storage

class ConcreteStorageTests: XCTestCase {
    
    var storage: Storage!
    let testDirectory = FileManager.directoryPath
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        if !FileManager.default.fileExists(atPath: testDirectory.path) {
            try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: true)
        }
        
        storage = ConcreteStorage()
    }
    
    override func tearDownWithError() throws {
        if FileManager.default.fileExists(atPath: testDirectory.path) {
            try FileManager.default.removeItem(at: testDirectory)
        }
        try super.tearDownWithError()
    }
    
    func testSaveImageData() async throws {
        let imageID = "testImage"
        let testData = "TestImageData".data(using: .utf8)!
        
        try await storage.save(imageID, data: testData)
        
        let savedFilePath = testDirectory.appendingPathComponent(imageID)
        XCTAssertTrue(FileManager.default.fileExists(atPath: savedFilePath.path), "File should exist at the path")
        
        let retrievedData = try Data(contentsOf: savedFilePath)
        XCTAssertEqual(retrievedData, testData, "Saved data should match the input data")
    }
    
    func testGetImageData() async throws {
        let imageID = "testImage"
        let testData = "TestImageData".data(using: .utf8)!
        
        let filePath = testDirectory.appendingPathComponent(imageID)
        try testData.write(to: filePath)
        
        let retrievedData = try await storage.getImageData(imageID)
        XCTAssertNotNil(retrievedData, "Retrieved data should not be nil")
        XCTAssertEqual(retrievedData, testData, "Retrieved data should match the saved data")
    }
    
    // MARK: - Test clearCachedDirectory() Method
    func testClearCachedDirectory() async throws {
        let imageID1 = "testImage1"
        let imageID2 = "testImage2"
        let testData = "TestImageData".data(using: .utf8)!
        
        // Pre-save some test files
        let filePath1 = testDirectory.appendingPathComponent(imageID1)
        let filePath2 = testDirectory.appendingPathComponent(imageID2)
        try testData.write(to: filePath1)
        try testData.write(to: filePath2)
        
        // Verify the files exist
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath1.path), "File 1 should exist before clearing")
        XCTAssertTrue(FileManager.default.fileExists(atPath: filePath2.path), "File 2 should exist before clearing")
        
        // Clear the cached directory
        try await storage.clearCachedDirectory()
        
        // Verify the directory no longer exists
        XCTAssertFalse(FileManager.default.fileExists(atPath: testDirectory.path), "Directory should be deleted")
    }
}
