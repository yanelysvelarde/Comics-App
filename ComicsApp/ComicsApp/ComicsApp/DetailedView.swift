import SwiftUI

struct MangaDetailView: View {
    let manga: Manga

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
            }
            .padding()
        }
        .navigationTitle(manga.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
