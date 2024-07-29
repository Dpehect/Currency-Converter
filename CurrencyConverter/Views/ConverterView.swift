import SwiftUI

struct ConverterView: View {
    @StateObject private var viewModel = ConverterViewModel()
    @State private var fromSearchText = ""
    @State private var toSearchText = ""

    var filteredFromCurrencies: [Currency] {
        if fromSearchText.isEmpty {
            return viewModel.currencies
        } else {
            return viewModel.currencies.filter { currency in
                currency.name.lowercased().contains(fromSearchText.lowercased()) ||
                currency.code.lowercased().contains(fromSearchText.lowercased())
            }
        }
    }

    var filteredToCurrencies: [Currency] {
        if toSearchText.isEmpty {
            return viewModel.currencies
        } else {
            return viewModel.currencies.filter { currency in
                currency.name.lowercased().contains(toSearchText.lowercased()) ||
                currency.code.lowercased().contains(toSearchText.lowercased())
            }
        }
    }

    var body: some View {
        VStack {
            Text("Currency Converter")
                .font(.title)
                .padding()

            VStack {
                TextField("Search From Currency", text: $fromSearchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("From", selection: $viewModel.selectedFromCurrency) {
                    ForEach(filteredFromCurrencies) { currency in
                        Text(currency.name).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.selectedFromCurrency) { _ in
                    viewModel.updateConversion()
                }
            }
            .padding(.bottom)

            VStack {
                TextField("Search To Currency", text: $toSearchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Picker("To", selection: $viewModel.selectedToCurrency) {
                    ForEach(filteredToCurrencies) { currency in
                        Text(currency.name).tag(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: viewModel.selectedToCurrency) { _ in
                    viewModel.updateConversion()
                }
            }
            .padding(.bottom)

            TextField("Amount", value: $viewModel.amount, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.amount) { _ in
                    viewModel.updateConversion()
                }

            Text("Converted Amount: \(viewModel.convertedAmount, specifier: "%.2f")")
                .padding()
        }
        .padding()
        .onAppear {
            viewModel.fetchCurrencies()
        }
    }
}

struct ConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ConverterView()
    }
}
