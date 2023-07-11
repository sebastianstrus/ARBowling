//
//  ContentView.swift
//  ARBall
//
//  Created by Sebastian Strus on 2023-07-11.
//

import SwiftUI
import RealityKit

enum ForceDirection {
    case up, down, left, right
    
    var symbol: String {
        switch self {
        case .up:
            return "arrow.up.circle.fill"
        case .down:
            return "arrow.down.circle.fill"
        case .left:
            return "arrow.left.circle.fill"
        case .right:
            return "arrow.right.circle.fill"
        }
    }
    
    // (x, y, z)
    var vector: SIMD3<Float> {
        switch self {
        case .up:
            return SIMD3<Float>(0, 0, -1)
        case .down:
            return SIMD3<Float>(0, 0, 1)
        case .left:
            return SIMD3<Float>(-1, 0, 0)
        case .right:
            return SIMD3<Float>(1, 0, 0)
        }
    }
}

struct ContentView : View {
    
    @State var showGameOver: Bool = false
    
    private let arView = ARGameView()
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            ControlsView(
                startApplyingForce: arView.startApplyingForce(direction:),
                stopApplyingForce: arView.stopApplyingForce)
        }.alert(isPresented: $showGameOver) {
            Alert(
                title: Text("You won!"),
                dismissButton: .default(Text("Ok")) {
                    showGameOver = false
                }
            )
        }.onReceive(NotificationCenter.default.publisher(for: PinSystem.gameOverNotification)) { _ in
            showGameOver = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let arView: ARGameView
    
    func makeUIView(context: Context) -> ARGameView {
        
        //let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        if let rollABall = try? Experience.loadRollABall() {
            setupComponent(in: rollABall)
            
            // Add the box anchor to the scene
            arView.scene.anchors.append(rollABall)
        }
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARGameView, context: Context) {}
    
    private func setupComponent(in rollBall: Experience.RollABall) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
        }
        
        rollBall.pinEntities.forEach { pin in
            pin.components[PinComponent.self] = PinComponent()
        }
    }
    
}

struct BallComponent: Component {
    static let query = EntityQuery(where: .has(BallComponent.self))
    var direction: ForceDirection?
}

class PinSystem: System {
    
    static let gameOverNotification = Notification.Name("GameOver")
    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        // Get all the pins in the scene
        let pins = context.scene.performQuery(PinComponent.query)
        // Check their upright orientation to determine if they've been knocked over
        if checkGameOver(pins: pins) {
            // if so, then post a game over information
            NotificationCenter.default.post(name: PinSystem.gameOverNotification, object: nil)
            
        }
    }
    
    private func checkGameOver(pins: QueryResult<Entity>) -> Bool {
        let upVector = SIMD3<Float>(0, 1, 0)
        
        for pin in pins {
            let pinUpVector = pin.transform.matrix.columns.1.xyz
            if dot(pinUpVector, upVector) > 0.01 {
                // The game is not over if there is still any pin standing
                return false
            }
        }
        
        return true
    }
}

struct PinComponent: Component {
    static let query = EntityQuery(where: .has(PinComponent.self))
}

class ARGameView: ARView {
    
    func startApplyingForce(direction: ForceDirection) {
        // Retrieve the ball entity from scene graph
        if let ball = scene.performQuery(BallComponent.query).first {
            
            // Get its BalllComponent, which holds the force direction
            var ballState = ball.components[BallComponent.self] as? BallComponent
            
            // Set the force direction to the incomming direction
            ballState?.direction = direction
            ball.components[BallComponent.self] = ballState
        }
    }
    
    func stopApplyingForce() {
        if let ball = scene.performQuery(BallComponent.query).first {
            
            // Get its BalllComponent, which holds the force direction
            var ballState = ball.components[BallComponent.self] as? BallComponent
            
            // Set the force direction to nil
            ballState?.direction = nil
            ball.components[BallComponent.self] = ballState
        }
    }
}

class BallPhysicsSystem: System {
    
    let ballSpeed: Float = 0.01
    
    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        if let ball = context.scene.performQuery(BallComponent.query).first {
            move(ball: ball)
        }
    }
    
    private func move(ball: Entity) {
        guard let ballState = ball.components[BallComponent.self] as? BallComponent,
              let physicsBody = ball as? HasPhysicsBody else {
            return
        }
        
        if let forceDirection = ballState.direction?.vector {
            let impulse = ballSpeed * forceDirection
            physicsBody.applyLinearImpulse(impulse, relativeTo: nil)
        }
    }
}

struct ControlsView: View {
    
    let startApplyingForce: (ForceDirection) -> Void
    let stopApplyingForce: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                arrowButton(direction: .up)
                Spacer()
            }
            
            HStack {
                arrowButton(direction: .left)
                Spacer()
                arrowButton(direction: .right)
            }
            
            HStack {
                Spacer()
                arrowButton(direction: .down)
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    func arrowButton(direction: ForceDirection) -> some View {
        Image(systemName: direction.symbol)
            .resizable()
            .frame(width: 75, height: 75)
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    startApplyingForce(direction)
                }
                .onEnded{ _ in
                    stopApplyingForce()
                }
            )
    }
}

extension Sequence {
    var first: Element? {
        var iterator = self.makeIterator()
        return iterator.next()
    }
}

extension SIMD4 where Scalar == Float {
    var xyz: SIMD3<Float> {
        SIMD3<Float>(x: x, y: y, z: z)
    }
}
#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
