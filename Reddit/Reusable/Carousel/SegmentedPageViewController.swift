//
//  SegmentedPageViewController.swift
//  Reddit
//
//  Created by Slehyder Martinez on 7/11/23.
//

import UIKit

protocol SegmentedPageControllerDelegate: AnyObject {
    func changedSegment(at index: Int)
    func controllerAtSegment(controller: UIViewController, for index: Int) -> UIViewController?
}

extension SegmentedPageControllerDelegate {
    func changedSegment(at index: Int) {}
    func controllerAtSegment(controller: UIViewController, for index: Int) -> UIViewController? { return controller }
}

class SegmentedPageViewController: UIPageViewController {
    
    init(controllers: [UIViewController]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.controllers = controllers
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isPagingEnabled = true
                subView.isScrollEnabled = false
            }
        }
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    weak var segmentsDelegate: SegmentedPageControllerDelegate?
    var controllers: [UIViewController]! {
        didSet {
            if !controllers.isEmpty {
                setViewControllers([controllers[currentSegment]],
                                   direction: .forward,
                                   animated: true,
                                   completion: nil)
            }
        }
    }
    
    var previousSegment = 0
    
    var currentSegment: Int = 0 {
        willSet {
            previousSegment = currentSegment
        }
        didSet {
            if currentSegment >= controllers.count && currentSegment < 0 {
                return
            }
            //user this when is artist profile
            guard let segments = segmentsDelegate,
                let viewController = segments.controllerAtSegment(controller: controllers[currentSegment], for: currentSegment) else {
                if controllers.count > 0 {
                    setViewControllers([controllers[currentSegment]],
                                       direction: .forward,
                                       animated: true,
                                       completion: nil)
                }
                return
            }
            let scrollDirection: UIPageViewController.NavigationDirection = previousSegment < currentSegment ? .forward : .reverse
            setViewControllers([viewController],
                               direction: scrollDirection,
                               animated: true,
                               completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentSegment = 0
    }
}

extension SegmentedPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let
            viewControllerIndex = controllers.firstIndex(of: viewController) else {
                return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard controllers.count != nextIndex else {
            return nil
        }
        
        guard controllers.count > nextIndex else {
            return nil
        }
        return controllers[nextIndex]
    }
}

extension SegmentedPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let controller = viewControllers?.first else {
            return
        }
        
        guard let viewControllerIndex = controllers.firstIndex(of: controller) else {
            return
        }
        
        segmentsDelegate?.changedSegment(at: viewControllerIndex)
    }
}

