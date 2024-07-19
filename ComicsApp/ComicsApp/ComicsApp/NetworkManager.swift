import Foundation

struct Manga: Codable, Identifiable {
    let id = UUID()
    let title: String
    let slug: String
    let genres: [String]
    let langs: [String]
    let cover: String
    let chapters: Double
    let volumes: Double
    var rating: Int?

    enum CodingKeys: String, CodingKey {
        case title, slug, genres, langs, cover, chapters, volumes
    }
}

struct SearchResult: Codable {
    let count: Int
    let next: String?
    let prev: String?
    let data: [Manga]
}

class MangaAPI {
    static let shared = MangaAPI()

    func searchManga(query: String, completion: @escaping (Result<[Manga], Error>) -> Void) {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        guard let url = URL(string: "https://mangareader-api.vercel.app/api/v1/search/\(encodedQuery)") else {
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

            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(SearchResult.self, from: data)
                completion(.success(result.data))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
