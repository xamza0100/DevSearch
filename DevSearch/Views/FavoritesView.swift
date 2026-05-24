import SwiftUI

struct FavoritesView: View {
    let favorites: [FavoriteUser]
    let onRemove: (FavoriteUser) -> Void

    var body: some View {
        List {
            if favorites.isEmpty {
                Text("No favorite users yet")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(favorites) { user in
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: user.avatarUrl)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name ?? user.login)
                                .font(.headline)

                            Text("@\(user.login)")
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            onRemove(user)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorites")
    }
}
