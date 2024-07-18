import SwiftUI

struct HomeView: View {
    @State private var searchTerm = ""
    @State private var mangas: [Manga] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    // Add background image if necessary
                }
                .searchable(text: $searchTerm, prompt: "Search Comics")
                .onSubmit(of: .search) {
                    searchManga()
                }

                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    List(mangas) { manga in
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
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manga Search")
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
                    self.mangas = mangas
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
