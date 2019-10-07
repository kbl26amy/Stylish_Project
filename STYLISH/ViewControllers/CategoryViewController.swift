import UIKit
import Alamofire
import ESPullToRefresh

let marketManager = MarketManager()
class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
CategoryDelegrate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBAction func backSegue(segue: UIStoryboardSegue) {
        guard segue.source is DetailViewController else {return}
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromProductList", sender: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailFromProductList", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let viewController = segue.destination as? DetailViewController else {return}

        if let section = clothesTableView.indexPathForSelectedRow?.section {
                viewController.passedProduct = femaleData[section]
        }

        guard let selectedindexPath = sender as? IndexPath else {return}

                viewController.passedProduct = femaleData[selectedindexPath.row]

    }

    @IBOutlet weak var switchButtonVariable: UIBarButtonItem!
    @IBAction func switchItemButton(_ sender: UIBarButtonItem) {

        if clothesCollectionView.alpha == CGFloat(0) {
            switchButtonVariable.image = #imageLiteral(resourceName: "Icons_24px_CollectionView")
            clothesCollectionView.alpha = 1
            clothesTableView.alpha = 0
        } else {
            self.clothesCollectionView.alpha = 0
            clothesTableView.alpha = 1
            switchButtonVariable.image = #imageLiteral(resourceName: "Icons_24px_ListView")
        }
    }
    var page: Int = 0
    var femaleData: [ProductObject] = []
    var catchPage: Int? = 0

    func manager(_ manager: MarketManager, didGet marketingfemale: FemaleObject) {
        DispatchQueue.main.async {
            self.catchPage = marketingfemale.paging
            self.femaleData.append(contentsOf: marketingfemale.data)
        
            self.clothesTableView.reloadData()
            self.clothesTableView.es.stopPullToRefresh()

            self.clothesCollectionView.reloadData()
            self.clothesCollectionView.es.stopPullToRefresh()

            if  self.catchPage == nil {
                self.clothesCollectionView.es.noticeNoMoreData()
                self.clothesTableView.es.noticeNoMoreData()
                self.clothesCollectionView.footer?.alpha = 1
                self.clothesTableView.footer?.alpha = 1
            }
        }
    }
    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }

    let fullScreenSize = UIScreen.main.bounds.size

    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var selectLine: UIView!

    var currentEndPoint: ProductEndPoint = .womenEendPoint
    @IBAction func isSelected(_ sender: UIButton) {

        resetColor(sender: femaleButton)
        resetColor(sender: maleButton)
        resetColor(sender: otherButton)

        switch sender {
        case femaleButton:
            currentEndPoint = .womenEendPoint
            selectLine.center = CGPoint(x: fullScreenSize.width / 6, y: 0)
            sender.setTitleColor(UIColor.black, for: .normal)
            self.femaleData = []
            page = 0
            marketManager.productList(endPoint: currentEndPoint.rawValue, page: page)

        case maleButton:
            currentEndPoint = .menEndPoint
            selectLine.center = CGPoint(x: fullScreenSize.width / 2, y: 0)
            sender.setTitleColor(UIColor.black, for: .normal)
            self.femaleData = []
            page = 0
            marketManager.productList(endPoint: currentEndPoint.rawValue, page: page)

        case otherButton:
            currentEndPoint = .accesoriesEndPoint
            selectLine.center = CGPoint(x: fullScreenSize.width / 6 * 5, y: 0)
            sender.setTitleColor(UIColor.black, for: .normal)
            self.femaleData = []
            page = 0
            marketManager.productList(endPoint: currentEndPoint.rawValue, page: page)

        default:
            break
        }
    }

    func resetColor (sender: UIButton) {
       sender.setTitleColor(UIColor.gray, for: .normal)

    }

    @IBOutlet weak var clothesTableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return femaleData.count

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "clothesCell", for: indexPath) as? ClothesTableViewCell else {
                return UITableViewCell()
        }
        let url = URL(string: femaleData[indexPath.row].mainImage)
        cell.clothesImage.kf.setImage(with: url)

        cell.clothesTitle.text = femaleData[indexPath.row].title
        cell.clothesPrice.text = "NT$\(femaleData[indexPath.row].price)"

        return cell
    }

    @IBOutlet weak var clothesCollectionView: UICollectionView!
    @IBOutlet weak var clothesCollectionViewController: UICollectionViewFlowLayout!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return femaleData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clothesCollectionCell", for: indexPath)
        guard let imageView = cell.viewWithTag(1) as? UIImageView else {
            return UICollectionViewCell()
        }
        guard let titleLabel = cell.viewWithTag(2) as? UILabel else {
            return UICollectionViewCell()
        }
        guard let priceLabel = cell.viewWithTag(3) as? UILabel else {
            return UICollectionViewCell()
        }
        let url = URL(string: femaleData[indexPath.row].mainImage)
        imageView.kf.setImage(with: url)

        titleLabel.text = femaleData[indexPath.row].title
        
        priceLabel.text = "NT$\(femaleData[indexPath.row].price)"
            
         return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        marketManager.categoryDelegrate = self
        clothesTableView.delegate = self
        clothesTableView.dataSource = self
        clothesCollectionView.delegate = self
        clothesCollectionView.dataSource = self

        isSelected(femaleButton)

        clothesTableView.separatorColor = UIColor.white
        clothesCollectionViewController.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        clothesCollectionViewController.itemSize = CGSize(width: (fullScreenSize.width - 47) / 2, height: 308)
        clothesCollectionViewController.minimumLineSpacing = 0
        clothesCollectionViewController.minimumInteritemSpacing = 15

        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()

        self.clothesTableView.es.addPullToRefresh {
            self.femaleData = []
            self.clothesTableView.es.resetNoMoreData()
            self.page = 0
            marketManager.productList(endPoint: self.currentEndPoint.rawValue, page: self.page)
        }
        self.clothesCollectionView.es.addPullToRefresh {
            self.femaleData = []
            self.clothesCollectionView.es.resetNoMoreData()
            self.page = 0
            marketManager.productList(endPoint: self.currentEndPoint.rawValue, page: self.page)
        }
        self.clothesTableView.es.addInfiniteScrolling {
            [unowned self] in
                self.page += 1
                marketManager.productList(endPoint: self.currentEndPoint.rawValue, page: self.page)
                self.clothesTableView.footer?.alpha = 1
        }
        self.clothesCollectionView.es.addInfiniteScrolling {
             [unowned self] in
                self.page += 1
                marketManager.productList(endPoint: self.currentEndPoint.rawValue, page: self.page)
                self.clothesCollectionView.footer?.alpha = 1
        }
     }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller

        self.tabBarController?.tabBar.isHidden = false
    }
}
