//
//  RowElement.swift
//  Hotels
//
//  Created by mp on 17.01.2026.
//

import SwiftUI

struct RowElement: View {
    var label: String
    var value: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(label)
                .font(.caption)
            Text(value)
                .font(.callout)
        }
    }
}
