// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI

/// Loading View
struct LoadingMarkView: UIViewControllerRepresentable {

    func updateUIViewController(_ uiViewController: Coordinator, context: UIViewControllerRepresentableContext<LoadingMarkView>) {
    }

    func makeUIViewController(context:Context) -> Coordinator{
        return context.coordinator
    }
    
    func makeCoordinator() -> Coordinator {
        let activityIndicator = Coordinator()
        return activityIndicator
    }
    
    class Coordinator: UIViewController {
        var container: UIView = UIView()
        var loadingView: UIView = UIView()
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        override func viewDidLoad() {
            super.viewDidLoad()
            showActivityIndicator(uiView: self.view)
        }
        func showActivityIndicator(uiView: UIView) {
            container.frame = uiView.frame
            container.center = uiView.center
            container.backgroundColor = UIColor(hex: 0x444444, alpha: 0.5)
            // container.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            container.frame = CGRect(x: 0, y: 0, width: UIScreen.main.nativeBounds.width, height: UIScreen.main.bounds.height)
            // container.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            loadingView.center = uiView.center
            loadingView.backgroundColor = UIColor(hex: 0xffffff, alpha: 0.7)
            loadingView.clipsToBounds = true
            loadingView.layer.cornerRadius = 10
        
            activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
            activityIndicator.style = UIActivityIndicatorView.Style.large
            activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);

            loadingView.addSubview(activityIndicator)
            container.addSubview(loadingView)
            uiView.addSubview(container)
            activityIndicator.startAnimating()
        }
        /*
            Hide activity indicator
            Actually remove activity indicator from its super view
            @param uiView - remove activity indicator from this view
        */
        public func hideActivityIndicator() {
            activityIndicator.stopAnimating()
            container.removeFromSuperview()
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }
}


