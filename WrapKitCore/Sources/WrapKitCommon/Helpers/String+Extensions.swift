//
//  String+Extensions.swift
//  WrapKit
//
//  Created by Stanislav Li on 11/12/23.
//

import Foundation

public extension String {
    static let post = "POST"
    static let patch = "PATCH"
    static let put = "PUT"
    static let get = "GET"
    static let delete = "DELETE"
}

public extension Optional where Wrapped == String {
    var isEmpty: Bool {
        guard let self else { return true }
        return self.isEmpty
    }
}

public extension String {
    var asHtmlAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
                
        return try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        )
    }
    
    func asDate(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}

public extension String {
    func numberFormatted(numberStyle: NumberFormatter.Style, groupingSeparator: String?, maxDigits: Int = 12) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        formatter.groupingSeparator = groupingSeparator ?? Locale.current.groupingSeparator
        formatter.locale = Locale.current
        
        guard let digits = Double(self.replacingOccurrences(of: formatter.groupingSeparator, with: "").prefix(maxDigits)) else { return "" }
        let number = NSNumber(value: digits)
        return formatter.string(from: number) ?? ""
    }
    
    func toIntFromFormatted(groupingSeparator: String? = nil) -> Int? {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = groupingSeparator ?? Locale.current.groupingSeparator
        
        let cleanString = self.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        return Int(cleanString)
    }
}
