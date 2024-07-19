import SwiftUI

struct HomeView: View {
    @State private var searchTerm = ""
    @State private var searchResults: [Manga] = []
    @State private var recommendations: [Manga] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isSearching = false

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    ZStack {
                      
                    }
                    .searchable(text: $searchTerm, prompt: "Search Comics")
                    .onSubmit(of: .search) {
                        searchManga()
                    }
                    .onChange(of: searchTerm) { newValue in
                        if newValue.isEmpty {
                            isSearching = false
                            fetchRecommendations()
                        } else {
                            isSearching = true
                            searchManga()
                        }
                    }
                    
                    if isLoading {
                        ProgressView("Loading...")
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    } else {
                        List(searchResults) { manga in
                            NavigationLink(destination: MangaDetailView(manga: manga)) {
                                HStack {
                                    if let coverURL = URL(string: manga.cover) {
                                        AsyncImage(url: coverURL) { phase in
                                            switch phase {
                                            case .empty:
                                                Color.gray.frame(width: 100, height: 150)
                                            case .success(let image):
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 100, height: 150)
                                            case .failure:
                                                Color.red.frame(width: 100, height: 150)
                                            @unknown default:
                                                Color.gray.frame(width: 100, height: 150)
                                            }
                                        }
                                    } else {
                                        Color.gray.frame(width: 100, height: 150)
                                    }
                                    VStack(alignment: .leading) {
                                        Text(manga.title)
                                            .font(.headline)
                                        Text(manga.slug)
                                            .font(.subheadline)
                                            .lineLimit(2)
                                        Text("Genres: \(manga.genres.joined(separator: ", "))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        StarRatingView(rating: Binding(
                                            get: { manga.rating ?? 0 },
                                            set: { newValue in
                                                var updatedManga = manga
                                                updatedManga.rating = newValue
                                                saveRating(for: updatedManga)
                                            }
                                        ))
                                    }
                                    Spacer()
                                    Button(action: {
                                        saveManga(manga)
                                    }) {
                                        Image(systemName: "bookmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                        .navigationTitle("Manga Search")
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            SavedContent()
                .tabItem {
                    Label("Saved Content", systemImage: "bookmark")
                }
        }
    }

    private func searchManga() {
        guard !searchTerm.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        MangaAPI.shared.searchManga(query: searchTerm) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let mangas):
                    self.searchResults = mangas.map { manga in
                        var mangaWithRating = manga
                        mangaWithRating.rating = loadRating(for: manga)
                        return mangaWithRating
                    }
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    private func saveManga(_ manga: Manga) {
        var savedMangas = loadSavedMangas()
        if !savedMangas.contains(where: { $0.id == manga.id }) {
            savedMangas.append(manga)
            saveSavedMangas(savedMangas)
        }
    }

    private func loadSavedMangas() -> [Manga] {
        guard let data = UserDefaults.standard.data(forKey: "savedMangas") else { return [] }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Manga].self, from: data)) ?? []
    }

    private func saveSavedMangas(_ mangas: [Manga]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(mangas) {
            UserDefaults.standard.set(data, forKey: "savedMangas")
        }
    }

    private func saveRating(for manga: Manga) {
        UserDefaults.standard.set(manga.rating, forKey: "rating_\(manga.id)")
    }

    private func loadRating(for manga: Manga) -> Int {
        return UserDefaults.standard.integer(forKey: "rating_\(manga.id)")
    }

    private func fetchRecommendations() {
        // Fetch and update recommendations
        // This method should populate the recommendations array
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
// en reparaciones, hubo un punto donde funciono... sad
    var body: some View {
        HStack {
            ForEach(1..<6) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(star <= rating ? .yellow : .gray)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

#Preview {
    HomeView()
}



