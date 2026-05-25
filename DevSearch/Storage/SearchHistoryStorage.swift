import Foundation

final class SearchHistoryStorage {
    private let key = "search_history"

    func getHistory() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func saveSearch(_ query: String) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedQuery.isEmpty else {
            return
        }

        var history = getHistory()

        history.removeAll {
            $0.lowercased() == trimmedQuery.lowercased()
        }

        history.insert(trimmedQuery, at: 0)

        let limitedHistory = Array(history.prefix(5))

        UserDefaults.standard.set(limitedHistory, forKey: key)
    }

    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
