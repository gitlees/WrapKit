//
//  PaginatedCollectionViewDatasource.swift
//  WrapKit
//
//  Created by Stas Lee on 5/8/23.
//

#if canImport(UIKit)
import UIKit

open class CollectionViewDatasource<Model>: NSObject, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public var getItems: (() -> [Model]) = { [] }
    public var selectAt: ((IndexPath) -> Void)?
    public var configureCell: ((UICollectionView, IndexPath, Model) -> UICollectionViewCell)?
    public var onRetry: (() -> Void)?
    public var showLoader = false
    public var hasMore = true
    public var minimumLineSpacingForSectionAt: ((Int) -> CGFloat) = { _ in 0 }
    public var loadNextPage: (() -> Void)?
    public var sizeForItemAt: ((IndexPath) -> CGSize)?
    public var didScrollTo: ((IndexPath) -> Void)?
    public var didScrollViewDidScroll: ((UIScrollView) -> Void)?
    
    public init(configureCell: ((UICollectionView, IndexPath, Model) -> UICollectionViewCell)? = nil) {
        self.configureCell = configureCell
        super.init()
    }
    
    public var loadingView: CollectionReusableView<UIActivityIndicatorView> = CollectionReusableView<UIActivityIndicatorView>()

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getItems().count
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let sizeForItemAt = sizeForItemAt {
            return sizeForItemAt(indexPath)
        } else if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.itemSize
        } else {
            return UICollectionViewFlowLayout.automaticSize
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let itemCount = getItems().count
        let thresholdIndex = itemCount - 1
        
        if indexPath.row == thresholdIndex, hasMore {
            loadNextPage?()
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = getItems().item(at: indexPath.row)
        if let configureCell = configureCell, let model = model { return configureCell(collectionView, indexPath, model) }
        return UICollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSectionAt(section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectAt?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard showLoader else { return .zero }
        guard let scrollDirection = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection else { return .zero }
        let width = scrollDirection == .horizontal ? loadingView.contentView.intrinsicContentSize.width * 3 : collectionView.bounds.width
        let height = scrollDirection == .horizontal ? loadingView.contentView.intrinsicContentSize.height : loadingView.contentView.intrinsicContentSize.height * 3
        return .init(width: width, height: height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view: CollectionReusableView<UIActivityIndicatorView> = collectionView.dequeueSupplementaryView(kind: kind, for: indexPath)
        view.contentView.hidesWhenStopped = false
        view.contentView.startAnimating()
        self.loadingView = view
        return view
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollViewDidScroll?(scrollView)
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = (scrollView as? UICollectionView)?.indexPathForItem(at: visiblePoint) else { return }
        didScrollTo?(indexPath)
    }
}
#endif
