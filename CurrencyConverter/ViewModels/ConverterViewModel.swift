import Foundation
import Combine

class ConverterViewModel: ObservableObject {
    @Published var selectedFromCurrency: Currency?
    @Published var selectedToCurrency: Currency?
    @Published var amount: Double = 0.0
    @Published var convertedAmount: Double = 0.0
    @Published var currencies: [Currency] = []

    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()

    init() {
        fetchCurrencies()
    }

    func fetchCurrencies() {
        apiService.fetchCurrencies()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch currencies: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] currencies in
                guard let self = self else { return }
                self.currencies = currencies
                if let firstCurrency = currencies.first {
                    self.selectedFromCurrency = firstCurrency
                    self.selectedToCurrency = currencies.first { $0.code != firstCurrency.code }
                }
                self.updateConversion()
            })
            .store(in: &cancellables)
    }

    func updateConversion() {
        guard let fromRate = selectedFromCurrency?.rate,
              let toRate = selectedToCurrency?.rate else {
            return
        }
        convertedAmount = amount * (toRate / fromRate)
    }
}
