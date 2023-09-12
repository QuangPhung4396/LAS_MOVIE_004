//
//  MoveDiaryVC.swift
//  Move004
//
//  Created by apple on 05/09/2023.
//

import UIKit
import FSPagerView

class MoveDiaryVC: BaseViewController,FSPagerViewDataSource,FSPagerViewDelegate,UIScrollViewDelegate{
    private var photos: [DMoviesDetail] = []
    var page = Int(arc4random_uniform(100))
    
    @IBOutlet weak var leadingPagerContrant: NSLayoutConstraint!
    @IBOutlet weak var trailingPagerContrant: NSLayoutConstraint!
    @IBOutlet weak var ratioPager: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pagerView.delegate = self
        pagerView.dataSource = self
        self.pagerView.transformer = FSPagerViewTransformer(type:.zoomOut)
        self.pagerView.itemSize = FSPagerView.automaticSize
        self.pagerView.decelerationDistance = 1
        if(isPad()) {
            leadingPagerContrant.constant = 120
            trailingPagerContrant.constant = 120
        }
       callAPI()
        
        // Do any additional setup after loading the view.
    }
    func callAPI() {
        showLoading()
        DApiManage.getInstance.getMovieTopRate(page: page, showLoading: true) { [self] data in
            let listMovie = data.data as! [DMoviesDetail]
            listMovie.forEach { moveItem in
                if(moveItem.poster_path != "" || moveItem.poster_path != "nil" ) {
                    self.photos.append(moveItem)

                }
            }
            if(self.photos.count > 0) {
                lblName.text = self.photos[0].title
            }
         //   self.page = self.page + 1
            self.pagerView.reloadData()
            self.hideLoading()
        }
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//           let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
//           if bottomEdge >= scrollView.contentSize.height {
//               callAPI()
//           }
//       }
    // MARK:- FSPagerViewDataSource
    
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.photos.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = self.photos[index]
        let uiView = FsWipeView(frame: CGRect(x: 0, y: 0, width: self.pagerView.layer.bounds.size.width, height: self.pagerView.layer.bounds.size.height))
        uiView.ivProfile.setImage(imageUrl: model.poster_path)
        cell.backgroundColor = .clear
        cell.addSubview(uiView)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
    }
  
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        let moveItem = self.photos[targetIndex]
        lblName.text = moveItem.title
    }
    func pagerView(_ pagerView: FSPagerView, didHighlightItemAt index: Int) {
        let moveItem = self.photos[index]
        let vc = ChooseMoveVC()
        vc.moveDetail = moveItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionSeach(_ sender: Any) {
        let vc = SearchVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
