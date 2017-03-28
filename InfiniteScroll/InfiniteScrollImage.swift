
import UIKit

class InfiniteScrollImage: UIView {
    
    var imageArray: [UIImage] = [UIImage(named: "image1")!,UIImage(named: "image2")!,UIImage(named: "image3")!]
    
    fileprivate lazy var currentIndex = 0
    fileprivate lazy var nextIndex = 0
    
    override func layoutSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(currentImage)
        scrollView.addSubview(nextImage)
        addSubview(pageControl)
    }
    
    fileprivate lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect(x: 0,
                                                         y: self.bounds.minY,
                                                         width: self.bounds.width,
                                                         height: self.bounds.height))
        scrollView.contentSize = CGSize(width: self.bounds.width * 3, height: scrollView.contentSize.height)
        scrollView.contentOffset = CGPoint(x: self.bounds.maxX, y: 0)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        return scrollView
    }()
    
    fileprivate lazy var currentImage: UIImageView = {
        let currentImage = UIImageView.init(frame: CGRect(x: self.bounds.maxX + 10,
                                                          y: 0,
                                                          width: self.bounds.width - 20,
                                                          height: self.bounds.height))
        currentImage.layer.cornerRadius = 22.0
        currentImage.layer.masksToBounds = true
        currentImage.image = self.imageArray[0]
        currentImage.backgroundColor = UIColor.gray
        return currentImage
    }()
    
    fileprivate lazy var nextImage: UIImageView = {
        let otherImage = UIImageView.init()
        otherImage.layer.cornerRadius = 22.0
        otherImage.layer.masksToBounds = true
        return otherImage
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl.init(frame: CGRect(x: self.bounds.width / 2 - 50,
                                                           y: self.bounds.maxY + 3,
                                                           width: 100,
                                                           height: 20))
        pageControl.numberOfPages = self.imageArray.count
        pageControl.pageIndicatorTintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        
        return pageControl
    }()
    
    enum Direction {
        case none
        case right
        case left
    }
    
    fileprivate var direction: Direction? {
        didSet {
            if direction == .right {
                nextImage.frame = CGRect(x: currentImage.frame.maxX + 20,
                                          y: 0,
                                          width: self.bounds.width - 20,
                                          height: self.bounds.height)
                self.nextIndex = self.currentIndex + 1
                if self.nextIndex > self.imageArray.count - 1 {
                    self.nextIndex = 0
                }
                
            } else if direction == .left {
                self.nextImage.frame = CGRect(x: 0,
                                               y: 0,
                                               width: self.bounds.width - 20,
                                               height: self.bounds.height)
                
                self.nextIndex = self.currentIndex - 1
                
                if self.nextIndex < 0 {
                    self.nextIndex = self.imageArray.count - 1
                }
            }
            
            self.nextImage.image = self.imageArray[self.nextIndex]
        }
    }
}

extension InfiniteScrollImage: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        direction = scrollView.contentOffset.x > UIScreen.main.bounds.width ? .right : .left
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollDidStop()
    }
    
    private func scrollDidStop() {
        self.direction = .none
        let index = scrollView.contentOffset.x / scrollView.bounds.size.width
        if index == 1 {
            return
        }
        currentImage.image = nextImage.image
        currentIndex = nextIndex
        scrollView.contentOffset = CGPoint(x: self.bounds.width, y: scrollView.contentOffset.y)
        pageControl.currentPage = currentIndex
    }
}
