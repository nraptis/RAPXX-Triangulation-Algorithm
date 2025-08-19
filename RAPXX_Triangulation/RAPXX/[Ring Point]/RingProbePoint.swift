//
//  ProbePoint.swift
//  RAPXX
//
//  Created by Nick Raptis on 11/21/23.
//

import Foundation

class RingProbePoint: PointProtocol {
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    var x = Float(0.0)
    var y = Float(0.0)
    
    var connections = [RingPoint]()
    var connectionCount = 0
    func addConnection(_ connection: RingPoint) {
        while connections.count <= connectionCount {
            connections.append(connection)
        }
        connections[connectionCount] = connection
        connectionCount += 1
    }
    
    var relaxDirectionX = Float(-1.0)
    var relaxDirectionY = Float(0.0)
    
    var ringIndex: Int = 0
    
    var isIllegal = true // On probe point, this always means GEOMTRY, probe geometry...
    
    var isMelded = false
    
    var isButtressCenter = false
    
    var isRelaxable = false
    var isRelaxDirectionComputed = false

    var firstConnectionSpoke = AnyPrecomputedLineSegment()
    var lastConnectionSpoke = AnyPrecomputedLineSegment()
    
    func calculateFirstAndLastConnectionSpokes() {
        if connectionCount == 1 {
            let connection = connections[0]
            firstConnectionSpoke.x1 = x
            firstConnectionSpoke.y1 = y
            firstConnectionSpoke.x2 = connection.x
            firstConnectionSpoke.y2 = connection.y
            firstConnectionSpoke.precompute()
            lastConnectionSpoke.copyFrom(firstConnectionSpoke)
        } else if connectionCount > 1 {
            let firstConnection = connections[0]
            firstConnectionSpoke.x1 = x
            firstConnectionSpoke.y1 = y
            firstConnectionSpoke.x2 = firstConnection.x
            firstConnectionSpoke.y2 = firstConnection.y
            firstConnectionSpoke.precompute()
            let lastConnection = connections[connectionCount - 1]
            lastConnectionSpoke.x1 = x
            lastConnectionSpoke.y1 = y
            lastConnectionSpoke.x2 = lastConnection.x
            lastConnectionSpoke.y2 = lastConnection.y
            lastConnectionSpoke.precompute()
        }
    }
    
    var meldContentionCount = 0
    
    unowned var ringProbeSegmentLeft: RingProbeSegment!
    unowned var ringProbeSegmentRight: RingProbeSegment!
    
    unowned var neighborLeft: RingProbePoint!
    unowned var neighborRight: RingProbePoint!
    
    var point: Point {
        Point(x: x,
              y: y)
    }
    
    func distanceSquared(x: Float, y: Float) -> Float {
        let diffX = x - self.x
        let diffY = y - self.y
        return diffX * diffX + diffY * diffY
    }
    
    func distanceSquared(ringProbePoint: RingProbePoint) -> Float {
        let diffX = ringProbePoint.x - self.x
        let diffY = ringProbePoint.y - self.y
        return diffX * diffX + diffY * diffY
    }
    
    func setup(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    func writeTo(_ ringProbePoint: RingProbePoint) {
        ringProbePoint.x = x
        ringProbePoint.y = y
        ringProbePoint.isButtressCenter = isButtressCenter
        ringProbePoint.connectionCount = 0
        for connectionIndex in 0..<connectionCount {
            let connection = connections[connectionIndex]
            ringProbePoint.addConnection(connection)
        }
    }
    
    func readFrom(_ ringProbePoint: RingProbePoint) {
        
        x = ringProbePoint.x
        y = ringProbePoint.y
        
        isButtressCenter = ringProbePoint.isButtressCenter
        
        
        connectionCount = 0
        for connectionIndex in 0..<ringProbePoint.connectionCount {
            let connection = ringProbePoint.connections[connectionIndex]
            addConnection(connection)
        }
    }
    
}

extension RingProbePoint: Hashable {
    static func == (lhs: RingProbePoint, rhs: RingProbePoint) -> Bool {
        lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
