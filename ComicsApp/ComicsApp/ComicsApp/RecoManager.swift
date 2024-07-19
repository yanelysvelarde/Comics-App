import Foundation

struct MangaDexRecommendation: Codable, Identifiable {
    let id: String
    let title: String
    let cover: String
    var rating: Int?
    let genres: [String]
    let slug: String
    

    
    
    enum CodingKeys: String, CodingKey {
        case id
        case attributes
    }

    enum AttributesCodingKeys: String, CodingKey {
        case title
        case description
        case tags
        case coverArt = "cover_art"
        case rating
    }

    enum TitleCodingKeys: String, CodingKey {
        case en
    }

    enum CoverArtCodingKeys: String, CodingKey {
        case fileName = "file_name"
    }

    enum TagCodingKeys: String, CodingKey {
        case attributes
    }

    enum TagAttributesCodingKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        
        let attributesContainer = try container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        
        // Extract title
        let titleContainer = try attributesContainer.nestedContainer(keyedBy: TitleCodingKeys.self, forKey: .title)
        title = try titleContainer.decode(String.self, forKey: .en)
        
        // Extract cover
        if let coverArtContainer = try? attributesContainer.nestedContainer(keyedBy: CoverArtCodingKeys.self, forKey: .coverArt) {
            cover = try coverArtContainer.decode(String.self, forKey: .fileName)
        } else {
            cover = ""
        }
        
        // Extract rating
        rating = try attributesContainer.decodeIfPresent(Int.self, forKey: .rating)
        
        // Extract genres
        var tagsContainer = try attributesContainer.nestedUnkeyedContainer(forKey: .tags)
        var genresArray = [String]()
        while !tagsContainer.isAtEnd {
            let tagContainer = try tagsContainer.nestedContainer(keyedBy: TagCodingKeys.self)
            let tagAttributesContainer = try tagContainer.nestedContainer(keyedBy: TagAttributesCodingKeys.self, forKey: .attributes)
            let genre = try tagAttributesContainer.decode(String.self, forKey: .name)
            genresArray.append(genre)
        }
        genres = genresArray

        // Slug might not be available directly from the API, so we'll use a placeholder or a derived value
        slug = title.replacingOccurrences(of: " ", with: "-").lowercased()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        
        var attributesContainer = container.nestedContainer(keyedBy: AttributesCodingKeys.self, forKey: .attributes)
        
        // Encode title
        var titleContainer = attributesContainer.nestedContainer(keyedBy: TitleCodingKeys.self, forKey: .title)
        try titleContainer.encode(title, forKey: .en)
        
        // Encode cover
        var coverArtContainer = attributesContainer.nestedContainer(keyedBy: CoverArtCodingKeys.self, forKey: .coverArt)
        try coverArtContainer.encode(cover, forKey: .fileName)
        
        // Encode rating
        try attributesContainer.encodeIfPresent(rating, forKey: .rating)
        
        // Encode genres
        var tagsContainer = attributesContainer.nestedUnkeyedContainer(forKey: .tags)
        for genre in genres {
            var tagContainer = tagsContainer.nestedContainer(keyedBy: TagCodingKeys.self)
            var tagAttributesContainer = tagContainer.nestedContainer(keyedBy: TagAttributesCodingKeys.self, forKey: .attributes)
            try tagAttributesContainer.encode(genre, forKey: .name)
        }
    }
}

struct MangaDexSearchResult: Codable {
    let data: [MangaDexRecommendation]
}

class MangaDexAPI {
    static let shared = MangaDexAPI()
    private let baseURL = "https://api.mangadex.org"

    func fetchRecommendations(completion: @escaping (Result<[MangaDexRecommendation], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/manga?limit=10")! // Adjust the endpoint as needed

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
                let result = try decoder.decode(MangaDexSearchResult.self, from: data)
                completion(.success(result.data))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

