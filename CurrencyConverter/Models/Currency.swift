import Foundation

struct Currency: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let code: String
    let rate: Double
}
