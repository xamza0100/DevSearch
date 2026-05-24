import Foundation

final class FavoritesStorage {
    private let key = "favorite_users"

    func getFavorites() -> [FavoriteUser] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }

        do {
            return try JSONDecoder().decode([FavoriteUser].self, from: data)
        } catch {
            print("Failed to decode favorites:", error)
            return []
        }
    }

    func saveFavorites(_ favorites: [FavoriteUser]) {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save favorites:", error)
        }
    }

    func add(_ user: FavoriteUser) {
        var favorites = getFavorites()

        guard !favorites.contains(user) else {
            return
        }

        favorites.append(user)
        saveFavorites(favorites)
    }

    func remove(_ user: FavoriteUser) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == user.id }
        saveFavorites(favorites)
    }

    func contains(_ user: FavoriteUser) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.id == user.id }
    }
}
