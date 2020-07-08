//
//  ContentView.swift
//  SmoothLineGraph
//
//  Created by Matt Selby on 7/8/20.
//  Copyright © 2020 Matt Selby. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LineGraph(points: [
            CGPoint(x: 1, y: 40),
            CGPoint(x: 2, y: 40),
            CGPoint(x: 3, y: 40),
            CGPoint(x: 6, y: 27),
            CGPoint(x: 10, y: 100)
        ]).frame(width: 300, height: 100, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
