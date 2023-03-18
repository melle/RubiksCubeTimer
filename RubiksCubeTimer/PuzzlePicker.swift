// Copyright © 2023 Thomas Mellenthin (privat). All rights reserved.

import SwiftUI

struct PuzzlePicker: View {
    let categories: [PuzzleCategory]
    let selectedCategory: Binding<PuzzleCategory>
    var body: some View {
        Menu(content: {
            Picker(selection: selectedCategory,
                   content: {
                ForEach(categories, id: \.self) { item in
                    Text(item.rawValue)
                }
            }, label: {
                Text("Select puzzle category")
            })
        }, label: {
            Image(systemName: "cube")
        })
    }
}

struct PuzzlePicker_Previews: PreviewProvider {
    static var previews: some View {
        PuzzlePicker(
            categories: PuzzleCategory.allCases,
            selectedCategory: .init(
                get: {
                    .cube3x3
                }, set: { _ in
                }))
    }
}
