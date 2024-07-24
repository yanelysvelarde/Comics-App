import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @State private var isSaved: Bool = false
    @State private var localRating: Int

    init(manga: Manga) {
        self.manga = manga
        _localRating = State(initialValue: manga.rating ?? 0) // default to 0
    }
    
    // Updated color definitions
    private let backgroundColor = Color(red: 244/255, green: 237/255, blue: 204/255) // #F4EDCC
    private let primaryColor = Color(red: 97/255, green: 150/255, blue: 166/255) // #6196A6
    private let accentColor = Color(red: 164/255, green: 206/255, blue: 149/255) // #A4CE95
    private let darkAccentColor = Color(red: 95/255, green: 93/255, blue: 156/255) // #5F5D9C

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let coverURL = URL(string: manga.cover) {
                    AsyncImage(url: coverURL) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.frame(height: 300)
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 300)
                        case .failure:
                            Color.red.frame(height: 300)
                        @unknown default:
                            Color.gray.frame(height: 300)
                        }
                    }
                } else {
                    Color.gray.frame(height: 300)
                }

                Text(manga.title)
                    .font(.custom("AmericanTypewriter", size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(darkAccentColor)

                Text("Slug: \(manga.slug)")
                    .font(.custom("AmericanTypewriter", size: 16))
                    .foregroundColor(.secondary)

                Text("Genres: \(manga.genres.joined(separator: ", "))")
                    .font(.custom("AmericanTypewriter", size: 16))
                    .foregroundColor(primaryColor)

                Text("Languages: \(manga.langs.joined(separator: ", "))")
                    .font(.custom("AmericanTypewriter", size: 16))
                    .foregroundColor(primaryColor)

                Text("Chapters: \(manga.chapters, specifier: "%.0f")")
                    .font(.custom("AmericanTypewriter", size: 16))
                    .foregroundColor(primaryColor)

                Text("Volumes: \(manga.volumes, specifier: "%.0f")")
                    .font(.custom("AmericanTypewriter", size: 16))
                    .foregroundColor(primaryColor)

                StarRatingView(rating: $localRating)
                    .padding(.vertical)
                    .background(backgroundColor) // Ensure background color is applied here

                Button(action: {
                    toggleSaveManga(manga)
                }) {
                    Text(isSaved ? "Unsave Manga" : "Save Manga")
                        .font(.custom("AmericanTypewriter", size: 18))
                        .padding()
                        .background(isSaved ? Color.red : primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
            .background(backgroundColor) 
        }
        .background(backgroundColor) //background color is applied to the ScrollView
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isSaved = loadSavedMangas().contains(where: { $0.id == manga.id })
        }
        .onChange(of: localRating) { newValue in
            saveRating(for: manga, rating: newValue)
        }
    }

    private func toggleSaveManga(_ manga: Manga) {
        var savedMangas = loadSavedMangas()
        if let index = savedMangas.firstIndex(where: { $0.id == manga.id }) {
            savedMangas.remove(at: index)
        } else {
            savedMangas.append(manga)
        }
        saveSavedMangas(savedMangas)
        self.isSaved = !self.isSaved
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

    private func saveRating(for manga: Manga, rating: Int) {
        UserDefaults.standard.set(rating, forKey: "rating_\(manga.id)")
    }
}

