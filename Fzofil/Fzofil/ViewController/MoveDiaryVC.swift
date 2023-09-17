//
//  MoveDiaryVC.swift
//  Move004
//
//  Created by apple on 05/09/2023.
//

import UIKit
import FSPagerView
import GoogleMobileAds

class MoveDiaryVC: BaseViewController,FSPagerViewDataSource,FSPagerViewDelegate,UIScrollViewDelegate{
    private var photos: [DMoviesDetail] = []
    var page = Int(arc4random_uniform(100))
    
    @IBOutlet weak var leadingPagerContrant: NSLayoutConstraint!
    @IBOutlet weak var trailingPagerContrant: NSLayoutConstraint!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var viewNativeAds: UIView!
    
    var adLoader: GADAdLoader!
    var nativeAdView: NativeSmallAdView!
    var nativeAd: GADNativeAd?
    
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
        
        adLoader = GADAdLoader(adUnitID: admod_small_native, rootViewController: self,
                               adTypes: [ .native ], options: nil)
        adLoader!.delegate = self
        adLoader!.load(GADRequest())
    }
    
    func setAdView(_ view: NativeSmallAdView) {
        nativeAdView = view
        self.viewNativeAds.addSubview(nativeAdView)
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary = ["_nativeAdView": nativeAdView!]
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
        self.viewNativeAds.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[_nativeAdView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary))
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

    // MARK:- FSPagerViewDataSource
    
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.photos.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let model = self.photos[index]
        let uiView = FsWipeView(frame: CGRect(x: 0, y: 0, width: self.pagerView.layer.frame.size.width, height: self.pagerView.layer.frame.size.height))
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

extension MoveDiaryVC : GADNativeAdLoaderDelegate, GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
    }
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        guard let nibObjects = Bundle.main.loadNibNamed("NativeSmallAdView", owner: nil, options: nil),
            let adView = nibObjects.first as? NativeSmallAdView else {
                assert(false, "Could not load nib file for adView")
                return
        }
        
        setAdView(adView)
        
        self.nativeAd = nativeAd
        nativeAdView.setViewForAds(nativeAd: self.nativeAd!)
        self.pagerView.layoutIfNeeded()
        self.pagerView.reloadData()
    }
}
