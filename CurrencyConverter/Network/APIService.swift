import Foundation
import Combine

class APIService {
    private let apiKey = "key"
    private var baseURL: String {
        return "https://api.exchangerate-api.com/v4/latest/USD"
    }

    func fetchCurrencies() -> AnyPublisher<[Currency], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CurrencyResponse.self, decoder: JSONDecoder())
            .map { response in
                response.rates.map { code, rate in
                    Currency(name: code, code: code, rate: rate)
                }
                .sorted { $0.name < $1.name }
            }
            .eraseToAnyPublisher()
    }
}

struct CurrencyResponse: Decodable {
    let rates: [String: Double]
}
