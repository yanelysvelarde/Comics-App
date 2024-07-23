import SwiftUI

struct TrendingView: View {
    @State private var trendingMangas: [TrendingManga] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                    Button("Retry") {
                        fetchTrendingMangas()
                    }
                }
            } else {
                List(trendingMangas) { manga in
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
                            Text("Rating: \(manga.rating, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Trending Manga")
            }
        }
        .onAppear {
            fetchTrendingMangas()
        }
    }

    private func fetchTrendingMangas() {
        isLoading = true
        errorMessage = nil

        TrendingAPI.shared.fetchTrendingManga { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let mangas):
                    self.trendingMangas = mangas
                case .failure(let error):
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    TrendingView()
}
