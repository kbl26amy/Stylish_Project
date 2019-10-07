import UIKit
import Kingfisher
import Foundation

class DetailViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,
                            UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? PopUpViewController else {return}
        viewController.receiveProduct = passedProduct
        
    }

    @IBAction func backSegue(segue: UIStoryboardSegue) {
        guard segue.source is PopUpViewController else {return}
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passedProduct.colors.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorDetaillidentifer", for: indexPath)
        guard let imageView = cell.viewWithTag(1) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        imageView.backgroundColor = UIColor(hexString: passedProduct.colors[indexPath.row].code)
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return cell
        }

    var passedProduct = ProductObject(
        id: 0,
        title: "",
        description: "",
        price: 0, texture: "",
        wash: "", place: "",
        note: "", story: "",
        colors: [ColorObject](),
        sizes: [String](),
        variants: [VariantObject](),
        mainImage: "", images: [String]())

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         if indexPath.row == 1 {
        guard let detailTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "detailTableViewCell", for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
        }

            var stock = 0
            for varient in passedProduct.variants {
                stock += varient.stock
            }

            var sizeLabel = "S - L"
            if passedProduct.sizes.count > 1 {
            for size in passedProduct.sizes {
                sizeLabel = "\(passedProduct.sizes[0]) - \(size) "
                }
            } else {
                sizeLabel = "\(passedProduct.sizes[0])"
            }

            let collectionScreen = detailTableViewCell.sizeLabel.bounds.size
            detailTableViewCell.colorCollectionView.delegate = self
            detailTableViewCell.colorCollectionView.dataSource = self
            detailTableViewCell.colorCollectionViewController.itemSize =
            CGSize(width: collectionScreen.height - 1, height: collectionScreen.height - 1 )

            detailTableViewCell.sizeLabel.text = sizeLabel
            detailTableViewCell.location.text = passedProduct.place
            detailTableViewCell.otherWords.text = passedProduct.note
            detailTableViewCell.structure.text = passedProduct.texture
            detailTableViewCell.washFunc.text = passedProduct.wash
            detailTableViewCell.storeNumber.text = "\(stock)"

            return detailTableViewCell

        } else {
        guard let descriptionTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: "descriptionTableViewCell", for: indexPath) as? DescriptionTableViewCell else {
                return UITableViewCell()
        }
        descriptionTableViewCell.homeDescriptionLabel.text = passedProduct.story
        return descriptionTableViewCell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 24)
        headerView.backgroundColor = UIColor.white

        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.frame = CGRect(x: 16, y: 24, width: 163, height: 27)
        titleLabel.text = passedProduct.title
        headerView.addSubview(titleLabel)

        let productDetailID = UILabel()
        productDetailID.textColor = UIColor.gray
        productDetailID.frame = CGRect(x: 16, y: 48, width: 160, height: 27)
        productDetailID.text = "\(passedProduct.id)"
        headerView.addSubview(productDetailID)

        let productDetailprice = UILabel()
        productDetailprice.textColor = UIColor.black
        productDetailprice.frame = CGRect(x: fullSize.width - 90, y: 24, width: 90, height: 27)
        productDetailprice.text = "NT$" + "\(passedProduct.price)"
        headerView.addSubview(productDetailprice)

        return headerView
    }

    @IBOutlet weak var detailviewController: UITableView!
    var fullSize = UIScreen.main.bounds.size
    var pageControl: UIPageControl!

    @IBOutlet weak var detailScrollView: UIScrollView!

    @IBOutlet weak var scrowviewImage: UIImageView!

    @IBAction func clickBack(_ sender: Any) {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        detailviewController.delegate = self
        detailviewController.dataSource = self

        detailviewController.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: 500)
        detailviewController.separatorStyle = .none
//        detailviewController.bounces = false
        detailScrollView.frame = CGRect(x: 0, y: 0, width: fullSize.width, height: 500)
        detailScrollView.contentSize = CGSize(width: fullSize.width * 5, height: 500)
        detailScrollView.isPagingEnabled = true
        detailScrollView.delegate = self

        let url = URL(string: passedProduct.mainImage)
        scrowviewImage.kf.setImage(with: url)

        // 建立 UIPageControl 設置位置及尺寸
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: fullSize.width * 0.85, height: 0))
        pageControl.center = CGPoint(x: fullSize.width * 0.13, y: fullSize.height - fullSize.height + 480)

        // 有幾頁 就是有幾個點點
        pageControl.numberOfPages = 4

        // 起始預設的頁數
        pageControl.currentPage = 0

        // 目前所在頁數的點點顏色
        pageControl.currentPageIndicatorTintColor = UIColor.black

        // 其餘頁數的點點顏色
        pageControl.pageIndicatorTintColor = UIColor.lightGray

        // 增加一個值改變時的事件
        pageControl.addTarget(self, action: #selector(DetailViewController.pageChanged), for: .valueChanged)

        // 加入到基底的視圖中
        // 因為比較後面加入 所以會蓋在 UIScrollView 上面
        detailScrollView.addSubview(pageControl)
    }
    // 滑動結束時
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // 左右滑動到新頁時 更新 UIPageControl 顯示的頁數
        let page = Int(detailScrollView.contentOffset.x / detailScrollView.frame.size.width)
        pageControl.currentPage = page
    }

    // 點擊點點換頁
    @objc func pageChanged(_ sender: UIPageControl) {
        // 依照目前圓點在的頁數算出位置
        var frame = detailScrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0

        // 再將 UIScrollView 滑動到該點
        detailScrollView.scrollRectToVisible(frame, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
extension UINavigationController {

    open override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }

    open override var childForStatusBarHidden: UIViewController? {
        return viewControllers.last
    }

}
