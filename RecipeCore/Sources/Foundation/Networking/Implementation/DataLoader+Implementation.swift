import Foundation

struct ConcreteDataLoader: DataLoader {    
    func load(urlStr: String) async throws -> Data {
        guard let url = URL(string: urlStr) else { throw NetworkError.invalidURL }
        
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        return data
    }
}
