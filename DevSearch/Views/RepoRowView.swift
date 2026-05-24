import SwiftUI

struct RepoRowView: View {
    let repo: GitHubRepo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repo.name)
                .font(.headline)

            if let description = repo.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                if let language = repo.language {
                    Label(language, systemImage: "circle.fill")
                }

                Spacer()

                Label("\(repo.stargazersCount)", systemImage: "star.fill")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
