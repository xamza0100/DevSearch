import Foundation

struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let name: String?
    let bio: String?
    let avatarUrl: String
    let followers: Int
    let following: Int
    let publicRepos: Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case name
        case bio
        case followers
        case following
        case avatarUrl = "avatar_url"
        case publicRepos = "public_repos"
    }
}
