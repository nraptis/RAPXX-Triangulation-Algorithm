//
//  MetalViewController.swift
//  RebuildEarth
//
//  Created by Nick Raptis on 2/10/23.
//

import UIKit

open class MetalViewController: UIViewController {
    
    public weak static var shared: MetalViewController?
    
    public let delegate: GraphicsDelegate
    public let graphics: Graphics
    public let metalEngine: MetalEngine
    public let metalPipeline: MetalPipeline
    public let metalLayer: CAMetalLayer
    
    private var timer: CADisplayLink?
    private var _isTimerRunning = false
    private var _isMetalEngineLoaded = false
    
    private var _isInitialized = false
    
    public nonisolated(unsafe) var isStereoscopicEnabled = false
    public var isBloomEnabled = true
    
    public var bloomPasses = 2// ? 3 : 2)
    public let stereoSpreadBase: Float
    public let stereoSpreadMax: Float
    
    public let metalView: MetalView
    public init(delegate: GraphicsDelegate,
                  width: Float,
                  height: Float) {
        
        self.stereoSpreadBase = ((UIDevice.current.userInterfaceIdiom == .pad)) ? Float(4.0) : Float(3.0)
        self.stereoSpreadMax = ((UIDevice.current.userInterfaceIdiom == .pad)) ? Float(12.0) : Float(9.0)
        
        let _metalView = MetalView(width: CGFloat(Int(width + 0.5)),
                                   height: CGFloat(Int(height + 0.5)))
        let _metalLayer = _metalView.layer as! CAMetalLayer
        let _metalEngine = MetalEngine(metalLayer: _metalLayer,
                                       width: width,
                                       height: height)
        let _metalPipeline = MetalPipeline(metalEngine: _metalEngine)
        let _graphics = Graphics(width: width,
                                 height: height,
                                 scaleFactor: Float(Int(_metalLayer.contentsScale + 0.5)))
        
        _metalEngine.graphics = _graphics
        _metalEngine.delegate = delegate
        
        _graphics.metalEngine = _metalEngine
        _graphics.metalPipeline = _metalPipeline
        _graphics.metalDevice = _metalEngine.metalDevice
        _graphics.metalView = _metalView
        
        delegate.graphics = _graphics
        
        self.delegate = delegate
        self.metalView = _metalView
        self.metalLayer = _metalLayer
        self.metalEngine = _metalEngine
        self.metalPipeline = _metalPipeline
        self.graphics = _graphics
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(notification:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        
        MetalViewController.shared = self
    }
    
    @objc func applicationWillResignActive(notification: NSNotification) {
        stopTimer()
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        startTimer()
    }
    
    public func startTimer() {
        if _isMetalEngineLoaded {
            if _isTimerRunning == false {
                _isTimerRunning = true
                timer?.invalidate()
                timer = nil
                previousTimeStamp = nil
                timer = CADisplayLink(target: self, selector: #selector(drawloop))
                
                //TODO:
                
                //timer?.preferredFrameRateRange = .init(minimum: 119.5, maximum: 120.5, preferred: 120)
                
                //timer?.preferredFrameRateRange = .init(minimum: 59.5, maximum: 60.5, preferred: 60)
                
                //timer?.preferredFrameRateRange = .init(minimum: 29.5, maximum: 30.5, preferred: 30)
                //timer?.preferredFrameRateRange = .init(minimum: 19.5, maximum: 20.5, preferred: 20)
                
                
                if let timer = timer {
                    timer.add(to: RunLoop.main, forMode: .default)
                }
            }
        }
    }
    
    public func stopTimer() {
        if _isTimerRunning == true {
            _isTimerRunning = false
            timer?.invalidate()
            timer = nil
            previousTimeStamp = nil
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        self.view = metalView
    }
    
    public func load() {
        
        metalEngine.load()
        metalPipeline.load()
        
        graphics.buildPipelineStateTable(metalPipeline: metalPipeline)
        
        _isMetalEngineLoaded = true
        
        delegate.load()
        
        startTimer()
    }
    
    public func loadComplete() {
        delegate.loadComplete()
    }
    
    private var previousTimeStamp: CFTimeInterval?
    @objc func drawloop() {
        if let timer = timer {
            var time = 0.0
            if let previousTimeStamp = previousTimeStamp {
                time = timer.timestamp - previousTimeStamp
            }
            update(deltaTime: Float(time), stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
            previousTimeStamp = timer.timestamp
            metalEngine.draw(isStereoscopicEnabled: isStereoscopicEnabled,
                             isBloomEnabled: isBloomEnabled,
                             bloomPasses: bloomPasses,
                             stereoSpreadBase: stereoSpreadBase,
                             stereoSpreadMax: stereoSpreadMax,
                             storeVideoTexture: false)
        }
    }
    
    open func update(deltaTime: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        if _isInitialized == false {
            _isInitialized = true
            delegate.initialize()
        }

        delegate.update(deltaTime: deltaTime,
                        stereoSpreadBase: stereoSpreadBase,
                        stereoSpreadMax: stereoSpreadMax,
                        isStereoscopicEnabled: isStereoscopicEnabled)
        
        
    }
}
