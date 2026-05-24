import Foundation

struct FavoriteUser: Codable, Identifiable, Equatable {
    let id: Int
    let login: String
    let name: String?
    let avatarUrl: String
}
