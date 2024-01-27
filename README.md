UICollectionView流水布局，通过cell高度排版，适配多个section的展示

使用纯Swift实现，可以直接下载并拖入项目中使用

以下是简单的实现：

    private lazy var flowLayout: WaterfallLayout = {
        let flowLayout = WaterfallLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.delegate = self
        return flowLayout
    }()

    extension UIViewController: WaterfallLayoutDelegate {
    /// 获取流水布局item尺寸
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, itemSize indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return CGSize(width: kScreenWidth, height: 120)
        case 1: return CGSize(width: kScreenWidth, height: 90)
        case 2:return CGSize(width: kScreenWidth - 12 * 2, height: 你的流水布局cell的动态高度)
        default: return .zero
        }
    }
    
    /// 获取流水布局每个section一行几个
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, numberOfColumns section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 2
        default: return 0
        }
    }
    
    /// 获取流水布局每个section的边距UIEdgeInsets
    func waterFlowLayout(_ layout: UICollectionViewFlowLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0: return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        case 1: return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        case 2: return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        default: return .zero
        }
    }
    
    /// 获取行间距
    func waterFlowLayout(_ layout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    /// 获取item间距
    func waterFlowLayout(_ layout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
