import UIKit

class SplashScreenViewController: UIViewController {
    
    private enum FrameType {
        case initial
        case final
    }
    
    private let images: [UIImage?] = [UIImage(named: "jordanChamp"),
                                      UIImage(named: "kobeChamp"),
                                      UIImage(named: "lebronChamp")]
    
    private var imagesViews: [UIImageView] = []
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        addBackgroundLogo()
        
        for i in 0..<images.count {
            setupImageView(with: images[i], counter: i)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentImages()
    }
    
    private func addBackgroundLogo() {
        let logoImageView = UIImageView(image: UIImage(named: "RoundedAppIcon"))
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupImageView(with image: UIImage?, counter: Int) {
        guard let unwrappedImage = image else { return }
        let imageView = UIImageView(image: unwrappedImage)
        imageView.contentMode = .scaleToFill
        imagesViews.append(imageView)
        view.addSubview(imageView)
        imageView.frame = getImageViewFrameFor(viewNumber: counter, frameType: .initial)
    }
    
    private func getImageViewFrameFor(viewNumber: Int, frameType: FrameType) -> CGRect {
        let defaultFrameSection = view.frame.height/CGFloat(images.count)
        
        if frameType == .initial {
            let x = -view.frame.width
            let y = defaultFrameSection * CGFloat(viewNumber)
            let width = view.frame.width
            let height = view.frame.height / CGFloat(images.count)
            
            return CGRect(x: x, y: y, width: width, height: height)
        } else if frameType == .final {
            let x = view.frame.minX
            let y = defaultFrameSection * CGFloat(viewNumber)
            let width = view.frame.width
            let height = view.frame.height / CGFloat(images.count)
            
            return CGRect(x: x, y: y, width: width, height: height)
        }
        
        return CGRect.zero
    }
    
    private func presentImages(number: Int = 0) {
        
        if number < images.count {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
                if let imageViewToAnimate = self?.imagesViews[number] {
                    guard let finalFrame = self?.getImageViewFrameFor(viewNumber: number, frameType: .final) else { return }
                    imageViewToAnimate.frame = finalFrame
                }
            }) { [weak self] (_) in
                self?.presentImages(number: number + 1)
            }
        } else {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
                self?.view.transform = CGAffineTransform(scaleX: 3, y: 3)
            }) { (_) in
                self.animateDisappearence()
            }
        }
    }
    
    private func animateDisappearence() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { [weak self] in
            guard let unwrappedView = self?.view else { return }
            unwrappedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (_) in
            NotificationCenter.default.post(Notification(name: Notification.Name.canHideSplashScreen))
        }
    }
}
