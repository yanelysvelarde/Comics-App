//
//  SavedContent.swift
//  ComicsApp
//
//  Created by Yanelys on 7/19/24.
//

import SwiftUI

struct SavedContent: View {
    @State private var savedMangas: [Manga] = []

    var body: some View {
        NavigationStack {
            ZStack {
                // Background color or image
                Color.white.ignoresSafeArea()

                // Main content
                if savedMangas.isEmpty {
                    Text("No saved content")
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    List(savedMangas) { manga in
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
                            }
                        }
                    }
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
}

struct SavedContent_Previews: PreviewProvider {
    static var previews: some View {
        SavedContent()
    }
}
