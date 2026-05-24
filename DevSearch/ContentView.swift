import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                searchBar

                content

                Spacer()
            }
            .padding()
            .navigationTitle("DevSearch")
            .toolbar {
                NavigationLink {
                    FavoritesView(
                        favorites: viewModel.favorites,
                        onRemove: { user in
                            viewModel.removeFavorite(user)
                        }
                    )
                } label: {
                    Image(systemName: "heart.fill")
                }
            }
        }
    }

    private var searchBar: some View {
        HStack {
            TextField("Enter GitHub username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }

            Button("Search") {
                Task {
                    await viewModel.search()
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Text("Search GitHub developers")
                .foregroundStyle(.secondary)

        case .loading:
            ProgressView("Loading...")

        case .empty:
            Text("Enter username first")
                .foregroundStyle(.secondary)

        case .error(let message):
            VStack(spacing: 12) {
                Text(message)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)

                Button("Try again") {
                    Task {
                        await viewModel.search()
                    }
                }
            }

        case .success(let user):
            ProfileView(
                user: user,
                repos: viewModel.repos,
                isFavorite: viewModel.isFavorite(user: user),
                onFavoriteTap: {
                    viewModel.toggleFavorite(user: user)
                }
            )
        }
    }
}
