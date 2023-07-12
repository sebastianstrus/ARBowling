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
    
    @State var showAlert: Bool = false
    @State var showGameOver: Bool = false
    @State var showWin: Bool = false
    
    
    
    private let arView = ARGameView()
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            ControlsView(
                startApplyingForce: arView.startApplyingForce(direction:),
                stopApplyingForce: arView.stopApplyingForce)
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(showGameOver ? "You lost!" : "You won!"),
                dismissButton: .default(Text("Ok")) {
                    showAlert = false
                }
            )
            

        }.onReceive(NotificationCenter.default.publisher(for: PinSystem.gameOverNotification)) { _ in
            showAlert = true
            showGameOver = true
        }.onReceive(NotificationCenter.default.publisher(for: CupSystem.winNotification)) { _ in
            showAlert = true
            showWin = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let arView: ARGameView
    
    func makeUIView(context: Context) -> ARGameView {
        
        //let arView = ARView(frame: .zero)
        
        if let rollABall = try? Experience.loadRollABall() {
            setupComponent(in: rollABall)
            
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
        
        if let cup = rollBall.cup {
            cup.components[CupComponent.self] = CupComponent()
        }
    }
}

struct BallComponent: Component {
    static let query = EntityQuery(where: .has(BallComponent.self))
    var direction: ForceDirection?
}

struct CupComponent: Component {
    static let query = EntityQuery(where: .has(CupComponent.self))
}

class PinSystem: System {
    
    static let gameOverNotification = Notification.Name("GameOver")
    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        let pins = context.scene.performQuery(PinComponent.query)
        if checkGameOver(pins: pins) {
            NotificationCenter.default.post(name: PinSystem.gameOverNotification, object: nil)
            
        }
    }
    
    private func checkGameOver(pins: QueryResult<Entity>) -> Bool {
        let upVector = SIMD3<Float>(0, 1, 0)
        
        for pin in pins {
            let pinUpVector = pin.transform.matrix.columns.1.xyz
           
            if dot(pinUpVector, upVector) < 0.01 {
                return true
            }
        }
        
        
        return false
    }
}

class CupSystem: System {
    
    static let winNotification = Notification.Name("Win")
    required init(scene: RealityKit.Scene) { }
    
    func update(context: SceneUpdateContext) {
        let cups = context.scene.performQuery(CupComponent.query)
        
        if checkWin(cups: cups) {
            NotificationCenter.default.post(name: CupSystem.winNotification, object: nil)
            
        }
    }
    
    private func checkWin(cups: QueryResult<Entity>) -> Bool {
        let upVector = SIMD3<Float>(0, 1, 0)
        
        for cup in cups {
            let cupUpVector = cup.transform.matrix.columns.1.xyz
            
            if dot(cupUpVector, upVector) < 0.01 {
                return true
            }
        }
        
        return false
    }
}

struct PinComponent: Component {
    static let query = EntityQuery(where: .has(PinComponent.self))
}

class ARGameView: ARView {
    
    func startApplyingForce(direction: ForceDirection) {
        if let ball = scene.performQuery(BallComponent.query).first {
            
            var ballState = ball.components[BallComponent.self] as? BallComponent
            
            ballState?.direction = direction
            ball.components[BallComponent.self] = ballState
        }
    }
    
    func stopApplyingForce() {
        if let ball = scene.performQuery(BallComponent.query).first {
            
            var ballState = ball.components[BallComponent.self] as? BallComponent
            
            ballState?.direction = nil
            ball.components[BallComponent.self] = ballState
        }
    }
}

class BallPhysicsSystem: System {
    
    let ballSpeed: Float = 0.03
    
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
            }//.padding(.bottom, 50)
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
