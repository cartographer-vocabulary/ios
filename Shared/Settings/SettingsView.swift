//
//  SettingsView.swift
//  cartographer2 (iOS)
//
//  Created by Tony Zhang on 4/2/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                AppIconView()
            }
            .navigationTitle("Settings")
        }
    }
}

