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

struct GameView : View {
    
    //@Environment(\.dismiss) var dismiss
    
    @State var showAlert: Bool = false
    @State var showGameOver: Bool = false
    @State var showWin: Bool = false
    
    var level: Level
    var number: Int
    
    
    private let arView = ARGameView()
    
    var body: some View {
        ZStack {
            ARViewContainer(level: level, number: number, arView: arView)
                .edgesIgnoringSafeArea(.all)
            
            ControlsView(
                startApplyingForce: arView.startApplyingForce(direction:),
                stopApplyingForce: arView.stopApplyingForce)
//            Button("Dismiss Modal") {
//                            dismiss()
//                        }
        }.alert(isPresented: $showAlert) {
            Alert(
                title: Text(showGameOver ? "You lost!" : "You win!"),
                dismissButton: .default(Text("Ok")) {
                    showAlert = false
                }
            )
            

//        }.onReceive(NotificationCenter.default.publisher(for: PinSystem.gameOverNotification)) { _ in
//            showAlert = true
//            showGameOver = true
//        }.onReceive(NotificationCenter.default.publisher(for: CupSystem.winNotification)) { _ in
//            showAlert = true
//            showWin = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let level: Level
    let number: Int
    let arView: ARGameView
    
    func makeUIView(context: Context) -> ARGameView {
        
        switch level {
        case .easy:
            switch number {
            case 1:
                if let rollABall = try? Experience.loadEasy1() {
                    setupComponentEasy1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 2:
                if let rollABall = try? Experience.loadEasy2() {
                    setupComponentEasy2(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 3:
                if let rollABall = try? Experience.loadEasy3() {
                    setupComponentEasy3(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 4:
                if let rollABall = try? Experience.loadEasy4() {
                    setupComponentEasy4(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 5:
                if let rollABall = try? Experience.loadEasy5() {
                    setupComponentEasy5(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 6:
                if let rollABall = try? Experience.loadEasy6() {
                    setupComponentEasy6(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            default:
                if let rollABall = try? Experience.loadEasy1() {
                    setupComponentEasy1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            }
        case .medium:
            switch number {
            case 1:
                if let rollABall = try? Experience.loadMedium1() {
                    setupComponentMedium1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 2:
                if let rollABall = try? Experience.loadMedium2() {
                    setupComponentMedium2(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 3:
                if let rollABall = try? Experience.loadMedium3() {
                    setupComponentMedium3(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 4:
                if let rollABall = try? Experience.loadMedium4() {
                    setupComponentMedium4(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            default:
                if let rollABall = try? Experience.loadMedium1() {
                    setupComponentMedium1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            }
        case .hard:
            switch number {
            case 1:
                if let rollABall = try? Experience.loadHard1() {
                    setupComponentHard1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            case 2:
                if let rollABall = try? Experience.loadHard2() {
                    setupComponentHard2(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            default:
                if let rollABall = try? Experience.loadHard1() {
                    setupComponentHard1(in: rollABall)
                    
                    arView.scene.anchors.append(rollABall)
                }
            }
        }
        

        return arView
    }
    
    func updateUIView(_ uiView: ARGameView, context: Context) {}
    
    
    
    
    private func setupComponentEasy1(in rollBall: Experience.Easy1) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentEasy2(in rollBall: Experience.Easy2) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentEasy3(in rollBall: Experience.Easy3) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentEasy4(in rollBall: Experience.Easy4) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentEasy5(in rollBall: Experience.Easy5) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentEasy6(in rollBall: Experience.Easy6) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentMedium1(in rollBall: Experience.Medium1) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentMedium2(in rollBall: Experience.Medium2) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentMedium3(in rollBall: Experience.Medium3) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentMedium4(in rollBall: Experience.Medium4) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentHard1(in rollBall: Experience.Hard1) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
    private func setupComponentHard2(in rollBall: Experience.Hard2) {
        if let ball = rollBall.ball {
            ball.components[BallComponent.self] = BallComponent()
            
        }
        
//        rollBall.pinEntities.forEach { pin in
//            pin.components[PinComponent.self] = PinComponent()
//        }
        
        rollBall.wallEntities.forEach { wall in
            wall.components[WallComponent.self] = WallComponent()
        }
        
//        if let cup = rollBall.cup {
//            cup.components[CupComponent.self] = CupComponent()
//        }
    }
    
}

struct BallComponent: Component {
    static let query = EntityQuery(where: .has(BallComponent.self))
    var direction: ForceDirection?
}

struct CupComponent: Component {
    static let query = EntityQuery(where: .has(CupComponent.self))
}

struct WallComponent: Component {
    static let query = EntityQuery(where: .has(WallComponent.self))
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
    
    let ballSpeed: Float = 0.015
    
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
            }.padding(.bottom, 50)
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
        GameView(level: .easy, number: 0)
    }
}
#endif
