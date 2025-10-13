import SwiftUI

struct MortgageCalculatorView: View {
    @AppStorage("Mortgage_PrincipalString") private var principalString: String = "350000"
    @AppStorage("Mortgage_AnnualRateString") private var annualRateString: String = "6.5" // percent
    @AppStorage("Mortgage_Years") private var years: Int = 30

    @FocusState private var principalFieldFocused: Bool

    private var principal: Double { Double(principalString) ?? 0 }
    private var annualRatePercent: Double { Double(annualRateString) ?? 0 }

    private var monthlyPayment: Double {
        let r = (annualRatePercent / 100.0) / 12.0
        let n = Double(years * 12)
        guard principal > 0, r >= 0, n > 0 else { return 0 }
        if r == 0 { return principal / n }
        let numerator = r * pow(1 + r, n)
        let denominator = pow(1 + r, n) - 1
        return principal * (numerator / denominator)
    }

    private var totalInterest: Double {
        let n = Double(years * 12)
        let totalPaid = monthlyPayment * n
        return max(totalPaid - principal, 0)
    }

    private static let currencyFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.maximumFractionDigits = 2
        return nf
    }()

    private static let percentFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.maximumFractionDigits = 2
        nf.multiplier = 1
        return nf
    }()

    private static let groupingFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.usesGroupingSeparator = true
        nf.maximumFractionDigits = 2
        return nf
    }()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Loan Details")) {
                    HStack {
                        Text("Loan Amount")
                        Spacer()
                        TextField("Amount", text: $principalString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($principalFieldFocused)
                            .onChange(of: principalFieldFocused) { wasFocused in
                                if wasFocused == false { // editing ended
                                    // Strip non-numeric except dot
                                    let cleaned = principalString.filter { ("0"..."9").contains($0) || $0 == "." }
                                    if let value = Double(cleaned) {
                                        principalString = Self.groupingFormatter.string(from: NSNumber(value: value)) ?? cleaned
                                    } else if cleaned.isEmpty {
                                        principalString = ""
                                    } else {
                                        principalString = cleaned
                                    }
                                }
                            }
                    }
                    HStack {
                        Text("Annual Interest Rate")
                        Spacer()
                        TextField("Rate", text: $annualRateString)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Stepper(value: $years, in: 1...40) {
                        Text("Term: \(years) years")
                    }
                }

                Section(header: Text("Results")) {
                    HStack {
                        Text("Monthly Payment")
                        Spacer()
                        Text(Self.currencyFormatter.string(from: NSNumber(value: monthlyPayment)) ?? "-")
                    }
                    HStack {
                        Text("Total Interest")
                        Spacer()
                        Text(Self.currencyFormatter.string(from: NSNumber(value: totalInterest)) ?? "-")
                    }
                }
            }
            .navigationTitle("Mortgage Calculator")
        }
    }
}

#Preview {
    MortgageCalculatorView()
}
