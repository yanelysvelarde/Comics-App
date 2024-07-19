import SwiftUI

struct MangaDetailView: View {
    let manga: Manga
    @State private var isSaved: Bool = false

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
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Slug: \(manga.slug)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Genres: \(manga.genres.joined(separator: ", "))")
                    .font(.subheadline)

                Text("Languages: \(manga.langs.joined(separator: ", "))")
                    .font(.subheadline)

                Text("Chapters: \(manga.chapters, specifier: "%.0f")")
                    .font(.subheadline)

                Text("Volumes: \(manga.volumes, specifier: "%.0f")")
                    .font(.subheadline)

                Button(action: {
                    toggleSaveManga(manga)
                }) {
                    Text(isSaved ? "Unsave Manga" : "Save Manga")
                        .font(.headline)
                        .padding()
                        .background(isSaved ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isSaved = loadSavedMangas().contains(where: { $0.id == manga.id })
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
}


