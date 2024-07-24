import SwiftUI

struct SavedContent: View {
    @State private var savedMangas: [Manga] = []

    // Updated color definitions
    private let backgroundColor = Color(red: 244/255, green: 237/255, blue: 204/255) // #F4EDCC
    private let primaryColor = Color(red: 95/255, green: 93/255, blue: 156/255) // #5F5D9C
    private let accentColor = Color(red: 97/255, green: 150/255, blue: 166/255) // #6196A6
    private let highlightColor = Color(red: 164/255, green: 206/255, blue: 149/255) // #A4CE95

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()

                if savedMangas.isEmpty {
                    Text("No saved content")
                        .foregroundColor(.gray)
                        .font(.custom("AmericanTypewriter", size: 20))
                } else {
                    List {
                        ForEach(savedMangas) { manga in
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
                                            .foregroundColor(primaryColor)
                                        Text(manga.slug)
                                            .font(.custom("AmericanTypewriter", size: 14))
                                            .lineLimit(2)
                                            .foregroundColor(accentColor)
                                        Text("Genres: \(manga.genres.joined(separator: ", "))")
                                            .font(.custom("AmericanTypewriter", size: 12))
                                            .foregroundColor(.secondary)
                                        StarRatingView(rating: Binding(
                                            get: { loadRating(for: manga) },
                                            set: { newValue in
                                                var updatedManga = manga
                                                updatedManga.rating = newValue
                                                saveRating(for: updatedManga)
                                            }
                                        ))
                                    }
                                }
                                .background(backgroundColor) // Apply background color here
                            }
                            .listRowBackground(backgroundColor) // Ensure background color matches
                        }
                        .onDelete(perform: deleteManga)
                    }
                    .listStyle(PlainListStyle()) // Ensures the List style doesn't affect background color
                }
            }
            .navigationTitle("Saved Manga")
            .onAppear {
                loadSavedMangas()
            }
        }
    }

    private func loadSavedMangas() {
        guard let data = UserDefaults.standard.data(forKey: "savedMangas") else {
            self.savedMangas = []
            return
        }
        let decoder = JSONDecoder()
        if let savedMangas = try? decoder.decode([Manga].self, from: data) {
            self.savedMangas = savedMangas
        } else {
            self.savedMangas = []
        }
    }

    private func saveRating(for manga: Manga) {
        UserDefaults.standard.set(manga.rating, forKey: "rating_\(manga.id)")
    }
    
    private func loadRating(for manga: Manga) -> Int {
        return UserDefaults.standard.integer(forKey: "rating_\(manga.id)")
    }

    private func deleteManga(at offsets: IndexSet) {
        savedMangas.remove(atOffsets: offsets)
        saveSavedMangas(savedMangas)
    }

    private func saveSavedMangas(_ mangas: [Manga]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(mangas) {
            UserDefaults.standard.set(data, forKey: "savedMangas")
        }
    }
}




struct SavedContent_Previews: PreviewProvider {
    static var previews: some View {
        SavedContent()
    }
}


