import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var state: ViewState<GitHubUser> = .idle
    @Published var repos: [GitHubRepo] = []
    @Published var favorites: [FavoriteUser] = []

    private let service = GitHubService()
    private let storage = FavoritesStorage()

    init() {
        favorites = storage.getFavorites()
    }

    func search() async {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedUsername.isEmpty else {
            state = .empty
            repos = []
            return
        }

        state = .loading
        repos = []

        do {
            let user = try await service.fetchUser(username: trimmedUsername)
            let userRepos = try await service.fetchRepos(username: trimmedUsername)

            repos = userRepos
            state = .success(user)
        } catch {
            repos = []
            state = .error("User not found or network connection failed")
        }
    }

    func toggleFavorite(user: GitHubUser) {
        let favoriteUser = FavoriteUser(
            id: user.id,
            login: user.login,
            name: user.name,
            avatarUrl: user.avatarUrl
        )

        if storage.contains(favoriteUser) {
            storage.remove(favoriteUser)
        } else {
            storage.add(favoriteUser)
        }

        favorites = storage.getFavorites()
    }

    func isFavorite(user: GitHubUser) -> Bool {
        let favoriteUser = FavoriteUser(
            id: user.id,
            login: user.login,
            name: user.name,
            avatarUrl: user.avatarUrl
        )

        return storage.contains(favoriteUser)
    }

    func removeFavorite(_ user: FavoriteUser) {
        storage.remove(user)
        favorites = storage.getFavorites()
    }
}
