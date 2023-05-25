//
//  Homepage.swift
//  hidenseek
//
//  Created by Jeremy Christopher on 25/05/23.
//

import SwiftUI

struct Homepage: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
            print("clicked")
        } label: {
            Text("PLAY")
        }
    }
}

struct Homepage_Previews: PreviewProvider {
    static var previews: some View {
        Homepage()
    }
}
