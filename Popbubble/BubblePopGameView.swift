import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var popped = false
    var velocity: CGSize
}

struct BubblePopGameView: View {
    @State private var bubbles: [Bubble] = []
    @State private var score = 0

    let maxBubbles = 20

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Set the background color to black
            
            ForEach(bubbles) { bubble in
                if !bubble.popped {
                    Button(action: {
                        popBubble(bubble)
                    }) {
                        Circle()
                            .foregroundColor(bubble.color)
                            .frame(width: bubble.size, height: bubble.size)
                            .scaleEffect(bubble.popped ? 0.01 : 1.0)
                            .opacity(bubble.popped ? 0.0 : 1.0)
                            .animation(bubble.popped ? .easeOut : .none)
                    }
                    .position(bubble.position)
                }
            }
            Text("Score: \(score)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(10)
                .padding(10)
        }
        .onAppear(perform: createBubbles)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()) { _ in
            moveBubbles()
        }
    }

    func createBubbles() {
        for _ in 0..<maxBubbles {
            let size = CGFloat.random(in: 30...80)
            let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            let y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
            let color = Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
            let velocity = CGSize(width: CGFloat.random(in: -2...2), height: CGFloat.random(in: -2...2))
            bubbles.append(Bubble(position: CGPoint(x: x, y: y), size: size, color: color, velocity: velocity))
        }
    }

    func moveBubbles() {
        for index in 0..<bubbles.count {
            if !bubbles[index].popped {
                bubbles[index].position.x += bubbles[index].velocity.width
                bubbles[index].position.y += bubbles[index].velocity.height
                
                if bubbles[index].position.x < -bubbles[index].size {
                    bubbles[index].position.x = UIScreen.main.bounds.width + bubbles[index].size
                } else if bubbles[index].position.x > UIScreen.main.bounds.width + bubbles[index].size {
                    bubbles[index].position.x = -bubbles[index].size
                }
                
                if bubbles[index].position.y < -bubbles[index].size {
                    bubbles[index].position.y = UIScreen.main.bounds.height + bubbles[index].size
                } else if bubbles[index].position.y > UIScreen.main.bounds.height + bubbles[index].size {
                    bubbles[index].position.y = -bubbles[index].size
                }
            }
        }
    }

    func popBubble(_ bubble: Bubble) {
        guard let index = bubbles.firstIndex(where: { $0.id == bubble.id }) else { return }
        
        withAnimation {
            bubbles[index].popped = true
            bubbles[index].size = 0 // Shrink the bubble
        }
        score += 1
    }
}

struct BubblePopGameView_Previews: PreviewProvider {
    static var previews: some View {
        BubblePopGameView()
    }
}
