import Foundation

struct TrendingManga: Codable, Identifiable {
    let id = UUID()
    let title: String
    let slug: String
    let cover: String
    let rating: Double
    let langs: [String]
    let chapters: Double
    let volumes: Double

    enum CodingKeys: String, CodingKey {
        case title, slug, cover, rating, langs, chapters, volumes
    }
}

struct TrendingResult: Codable {
    let count: Int
    let next: String?
    let prev: String?
    let data: [TrendingManga]
}

class TrendingAPI {
    static let shared = TrendingAPI()

    func fetchTrendingManga(completion: @escaping (Result<[TrendingManga], Error>) -> Void) {
        guard let url = URL(string: "https://mangareader-api.vercel.app/api/v1/trending") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Print raw JSON data for debugging
            if let json = String(data: data, encoding: .utf8) {
                print("JSON Response: \(json)")
            }

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(TrendingResult.self, from: data)
                completion(.success(result.data))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
