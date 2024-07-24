import SwiftUI

struct TrendingView: View {
    @State private var trendingMangas: [TrendingManga] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let darkAccentColor = Color(red: 95/255, green: 93/255, blue: 156/255) //#5F5D9C
    private let primaryColor = Color(red: 97/255, green: 150/255, blue: 166/255) //#6196A6

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: darkAccentColor))
            } else if let errorMessage = errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.custom("AmericanTypewriter", size: 20).bold())
                    Button("Retry") {
                        fetchTrendingMangas()
                    }
                    .font(.custom("AmericanTypewriter", size: 20).bold())
                    .foregroundColor(primaryColor)
                }
            } else {
                List(trendingMangas) { manga in
                    HStack {
                        if let coverURL = URL(string: manga.cover) {
                            AsyncImage(url: coverURL) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray.frame(width: 120, height: 180)
                                case .success(let image):
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 120, height: 180)
                                case .failure:
                                    Color.red.frame(width: 120, height: 180)
                                @unknown default:
                                    Color.gray.frame(width: 120, height: 180)
                                }
                            }
                        } else {
                            Color.gray.frame(width: 120, height: 180)
                        }
                        VStack(alignment: .leading) {
                            Text(manga.title)
                                .font(.custom("AmericanTypewriter", size: 22).bold())
                                .foregroundColor(darkAccentColor)
                            Text(manga.slug)
                                .font(.custom("AmericanTypewriter", size: 16).bold())
                                .lineLimit(2)
                                .foregroundColor(primaryColor)
                            Text("Rating: \(manga.rating, specifier: "%.2f")")
                                .font(.custom("AmericanTypewriter", size: 14).bold())
                                .foregroundColor(.secondary)
                        }
                        .padding(.leading, 10)
                    }
                }
                .navigationTitle("Trending Manga")
                .font(.custom("AmericanTypewriter", size: 20).bold())
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
