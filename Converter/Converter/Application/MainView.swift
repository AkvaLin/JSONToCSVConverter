//
//  MainView.swift
//  Converter
//
//  Created by Никита Пивоваров on 11.09.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GeneratorView()
                .tabItem {
                    Text("Generator")
                }
            ConverterView()
                .tabItem {
                    Text("Converter")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
