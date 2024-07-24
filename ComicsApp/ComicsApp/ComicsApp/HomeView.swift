import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @State private var searchTerm = ""
    @State private var searchResults: [Manga] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isSearching = false
    @State private var isAnimating: Bool = false

    private let backgroundColor = Color(red: 244/255, green: 237/255, blue: 204/255) //#F4EDCC
    private let primaryColor = Color(red: 97/255, green: 150/255, blue: 166/255) //#6196A6
    private let accentColor = Color(red: 164/255, green: 206/255, blue: 149/255) //#A4CE95
    private let darkAccentColor = Color(red: 95/255, green: 93/255, blue: 156/255) //#5F5D9C 

    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    ZStack {
                        // UI and stuff
                    }
                    .searchable(text: $searchTerm, prompt: "Search Comics")
                    .onSubmit(of: .search) {
                        searchManga()
                    }
                    .onChange(of: searchTerm) { newValue in
                        if newValue.isEmpty {
                            isSearching = false
                            searchManga()
                        } else {
                            isSearching = true
                            searchManga()
                        }
                    }

                    if isLoading {
                        VStack {
                            AnimatedImage(name: "vidio-output.gif", isAnimating: $isAnimating)
                                .frame(width: 100, height: 100)
                            Text("Loading...")
                                .font(.custom("AmericanTypewriter", size: 20))
                                .foregroundColor(darkAccentColor)
                        }
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom("AmericanTypewriter", size: 16))
                    } else {
                        List {
                            ForEach(searchResults) { manga in
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
                                                .font(.custom("AmericanTypewriter", size: 18))
                                                .foregroundColor(darkAccentColor)
                                            Text(manga.slug)
                                                .font(.custom("AmericanTypewriter", size: 14))
                                                .lineLimit(2)
                                                .foregroundColor(primaryColor)
                                            Text("Genres: \(manga.genres.joined(separator: ", "))")
                                                .font(.custom("AmericanTypewriter", size: 12))
                                                .foregroundColor(.secondary)
                                            StarRatingView(rating: Binding(
                                                get: { loadRating(for: manga) },
                                                set: { newValue in
                                                    var updatedManga = manga
                                                    updatedManga.rating = newValue
                                                    saveRating(for: updatedManga)
                                                    // Refresh search results to update ratings
                                                    if let index = searchResults.firstIndex(where: { $0.id == updatedManga.id }) {
                                                        searchResults[index].rating = newValue
                                                    }
                                                }
                                            ))
                                        }
                                        Spacer()
                                        Button(action: {
                                            saveManga(manga)
                                        }) {
                                            Image(systemName: "bookmark")
                                                .foregroundColor(accentColor)
                                        }
                                    }
                                    .padding()
                                    .background(backgroundColor) //background color
                                }
                                .listRowBackground(backgroundColor) //list row background color
                            }
                        }
                        .listStyle(PlainListStyle()) //for list style to do not affect background color
                    }

                    NavigationLink(destination: TrendingView()) {
                        Text("Trending Manga")
                            .font(.custom("AmericanTypewriter", size: 18))
                            .padding()
                            .background(primaryColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .background(backgroundColor)
                .navigationTitle("Manga Search")
                .font(.custom("AmericanTypewriter", size: 18))
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }

            SavedContent()
                .tabItem {
                    Label("Saved Content", systemImage: "bookmark")
                }
                .background(backgroundColor)
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
}

struct StarRatingView: View {
    @Binding var rating: Int
    
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


