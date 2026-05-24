import SwiftUI

struct ProfileView: View {
    let user: GitHubUser
    let repos: [GitHubRepo]
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileHeader
                repoList
            }
            .padding(.top)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 110, height: 110)
            .clipShape(Circle())

            Text(user.name ?? user.login)
                .font(.title2)
                .fontWeight(.bold)

            Text("@\(user.login)")
                .foregroundStyle(.secondary)

            if let bio = user.bio {
                Text(bio)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 18) {
                statView(title: "Followers", value: user.followers)
                statView(title: "Following", value: user.following)
                statView(title: "Repos", value: user.publicRepos)
            }

            Button {
                onFavoriteTap()
            } label: {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var repoList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Repositories")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            if repos.isEmpty {
                Text("No repositories found")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(repos) { repo in
                    RepoRowView(repo: repo)
                }
            }
        }
    }

    private func statView(title: String, value: Int) -> some View {
        VStack {
            Text("\(value)")
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
