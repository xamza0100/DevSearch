import SwiftUI

struct ProfileView: View {
    let user: GitHubUser
    let repos: [GitHubRepo]
    let isFavorite: Bool
    let onFavoriteTap: () -> Void
    let onRefresh: () async -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                profileCard
                repoList
            }
            .padding(.top, 8)
        }
        .refreshable {
            await onRefresh()
        }
    }
    private var profileCard: some View {
        VStack(spacing: 14) {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 110, height: 110)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(.background, lineWidth: 4)
            }
            .shadow(radius: 8)

            VStack(spacing: 4) {
                Text(user.name ?? user.login)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("@\(user.login)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if let bio = user.bio, !bio.isEmpty {
                Text(bio)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 8)
            }

            HStack(spacing: 12) {
                statCard(title: "Followers", value: user.followers)
                statCard(title: "Following", value: user.following)
                statCard(title: "Repos", value: user.publicRepos)
            }

            Button {
                let impact = UIImpactFeedbackGenerator(style: .medium)
                impact.impactOccurred()
                onFavoriteTap()
            } label: {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "heart.fill" : "heart"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(.background)
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
        )
    }

    private var repoList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Repositories")
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()

                Text("\(repos.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if repos.isEmpty {
                Text("No repositories found")
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(repos) { repo in
                    RepoRowView(repo: repo)
                }
            }
        }
    }

    private func statCard(title: String, value: Int) -> some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.secondary.opacity(0.08))
        )
    }
}
