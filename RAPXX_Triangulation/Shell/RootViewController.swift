//
//  RootViewController.swift
//  Jiggle III
//
//  Created by Nick Raptis on 11/8/23.
//

import UIKit

class RootViewController: UIViewController {
    
    lazy var containerView: UIView = {
        let result = UIView(frame: .zero)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    let rootViewModel: RootViewModel
    required init(rootViewModel: RootViewModel) {
        
        self.rootViewModel = rootViewModel
        
        super.init(nibName: "RootViewController", bundle: .main)
        
        view.addSubview(containerView)
        
        view.addConstraints([
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.layoutIfNeeded()
        
    }
    
    weak var timer: Timer?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var isPushing = false
    private var viewController: UIViewController?
    func push(viewController: UIViewController,
              fromOrientation: Orientation,
              toOrientation: Orientation,
              fixedOrientation: Bool,
              animated: Bool,
              reversed: Bool,
              completion: @escaping () -> Void) {
        
        if isPushing {
            fatalError("Double Push, RVC...")
        }
        
        if let view = viewController.view {
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)
            addChild(viewController)
            viewController.didMove(toParent: self)
            
            if fixedOrientation {
                var width = Device.widthPortrait
                var height = Device.heightPortrait
                switch toOrientation {
                case .landscape:
                    width = Device.widthLandscape
                    height = Device.heightLandscape
                case .portrait:
                    width = Device.widthPortrait
                    height = Device.heightPortrait
                }
                containerView.addConstraints([
                    view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                    view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
                ])
                view.addConstraints([
                    NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(width)),
                    NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(height))
                ])
            } else {
                containerView.addConstraints([
                    view.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                    view.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                    view.topAnchor.constraint(equalTo: containerView.topAnchor),
                    view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
            }
            view.layoutIfNeeded()
        }
        
        let previousViewController = self.viewController
        self.viewController = viewController
        
        if let previousViewController = previousViewController {
            
            if let metalViewController = previousViewController as? MetalViewController {
                print("Metal View Controller - Stopping Timer")
                metalViewController.stopTimer()
            }
        }
        
        //
        //If the supported interface orientations changes, this may cause an unwanted
        //rotation. However, it is best to always reload the supported orientations.
        //If we do not always do this, we will lose rotate-ability when switching
        //from locked orientation into a switch-able orientation.
        //
        
        setNeedsUpdateOfSupportedInterfaceOrientations()
        
        if fromOrientation.isLandscape != toOrientation.isLandscape {
            if fixedOrientation {
                var interfaceOrientationMask = UIInterfaceOrientationMask(rawValue: 0)
                if toOrientation.isLandscape {
                    interfaceOrientationMask = interfaceOrientationMask.union(.landscapeLeft)
                    interfaceOrientationMask = interfaceOrientationMask.union(.landscapeRight)
                } else {
                    interfaceOrientationMask = interfaceOrientationMask.union(.portrait)
                    interfaceOrientationMask = interfaceOrientationMask.union(.portraitUpsideDown)
                }
                rootViewModel.windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: interfaceOrientationMask)) { error in
                    print("Request Geometry Update Error!")
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        if !animated {
            if let previousViewController = previousViewController {
                previousViewController.view.layer.removeAllAnimations()
                previousViewController.view.removeFromSuperview()
            }
            completion()
        } else {
            guard let previousViewController = previousViewController else {
                completion()
                return
            }
            
            let previousStartOffsetX: CGFloat = 0.0
            let previousStartOffsetY: CGFloat = 0.0
            var previousEndOffsetX: CGFloat = 0.0
            var previousEndOffsetY: CGFloat = 0.0
            
            var currentStartOffsetX: CGFloat = 0.0
            var currentStartOffsetY: CGFloat = 0.0
            let currentEndOffsetX: CGFloat = 0.0
            let currentEndOffsetY: CGFloat = 0.0
            
            if fromOrientation.isLandscape == toOrientation.isLandscape {
                // Animate in from the right / left, using width...
                let amount = toOrientation.isLandscape ? Device.widthLandscape : Device.widthPortrait
                if reversed {
                    previousEndOffsetX = CGFloat(amount)
                    currentStartOffsetX = CGFloat(-amount)
                } else {
                    previousEndOffsetX = CGFloat(-amount)
                    currentStartOffsetX = CGFloat(amount)
                }
                
            } else {
                // Animate in from the bottom / top, using max dimension...
                
                let amount = max(Device.widthPortrait, Device.heightPortrait)
                if reversed {
                    previousEndOffsetY = CGFloat(amount)
                    currentStartOffsetY = CGFloat(-amount)
                } else {
                    previousEndOffsetY = CGFloat(-amount)
                    currentStartOffsetY = CGFloat(amount)
                }
            }
            
            let previousStartAffine = CGAffineTransform.init(translationX: previousStartOffsetX, y: previousStartOffsetY)
            let previousEndAffine = CGAffineTransform.init(translationX: previousEndOffsetX, y: previousEndOffsetY)
            let currentStartAffine = CGAffineTransform.init(translationX: currentStartOffsetX, y: currentStartOffsetY)
            let currentEndAffine = CGAffineTransform.init(translationX: currentEndOffsetX, y: currentEndOffsetY)
            
            previousViewController.view.transform = previousStartAffine
            viewController.view.transform = currentStartAffine
            
            isPushing = true
            
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                
                
                UIView.animate(withDuration: 0.44) {
                    previousViewController.view.transform = previousEndAffine
                    viewController.view.transform = currentEndAffine
                } completion: { _ in
                    previousViewController.view.layer.removeAllAnimations()
                    previousViewController.view.removeFromSuperview()
                    self.viewController = viewController
                    self.isPushing = false
                    completion()
                }
            
            //}
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            rootViewModel.orientation = .landscape
        } else {
            rootViewModel.orientation = .portrait
        }
        
        coordinator.animate { _ in
            
        } completion: { _ in
            
        }
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
    
}
