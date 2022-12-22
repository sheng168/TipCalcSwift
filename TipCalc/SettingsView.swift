//
//  SettingsView.swift
//  TipCalc
//
//  Created by Jin.Yu on 2/16/20.
//  Copyright © 2020 Jin.Yu. All rights reserved.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    var body: some View {
        Text("Settings")
            .onAppear() {
                // https://developer.apple.com/documentation/storekit/skstorereviewcontroller
                SKStoreReviewController.requestReview()
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
