//
//  Double.swift
//  Let'sGo
//
//  Created by Sarthak Agrawal on 06/09/23.
//

import Foundation

extension Double{
    private var currencyFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = "₹"
        return formatter
    }
    
    func toCurrency() -> String{
        return currencyFormatter.string(for: self) ?? ""
    }
}
