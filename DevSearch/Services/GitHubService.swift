import Foundation

final class GitHubService {
    private let baseURL = "https://api.github.com"

    func fetchUser(username: String) async throws -> GitHubUser {
        guard let url = URL(string: "\(baseURL)/users/\(username)") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(GitHubUser.self, from: data)
    }

    func fetchRepos(username: String) async throws -> [GitHubRepo] {
        guard let url = URL(string: "\(baseURL)/users/\(username)/repos?per_page=20") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        let repos = try JSONDecoder().decode([GitHubRepo].self, from: data)

        return repos.sorted {
            $0.stargazersCount > $1.stargazersCount
        }
    }
}
