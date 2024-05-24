//
//  ScratchView.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 22.05.2024.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
    var lineWidth: Double = 50.0
}

struct ScratchView: View {
    // MARK: Variables
    let image: Image
    let text: String
    
    @State private var currentLine = Line()
    @State private var lines = [Line]()
    
    var body: some View {
        ZStack(alignment: .top) {
            image
                .resizable()
                .bordered(cornerRadius: GlobalConstants.cornerRadius)
                .scaledToFit()
                .padding(1)
                .overlay {
                    RoundedRectangle(cornerRadius: GlobalConstants.cornerRadius)
                        .fill(.bg)
                        .overlay {
                            Text(text)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .mask(
                            Canvas { context, _ in
                                for line in lines {
                                    var path = Path()
                                    path.addLines(line.points)
                                    context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                                }
                            }
                        )
                        .gesture(dragGesture)
                }
        }
    }
    
    // MARK: Drag gesture
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                let newPoint = value.location
                currentLine.points.append(newPoint)
                lines.append(currentLine)
            }
    }
}

#Preview {
    ScratchView(image: Image("nature"), text: "Joke")
}
