import UIKit
import CoreData

class PopUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UIApplicationDelegate, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var colorCollectionView: UICollectionView!

    @IBOutlet weak var sizeCollectionView: UICollectionView!

    @IBOutlet weak var decreaseButton: UIButton!

    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var chooseCountTextField: UITextField!
    
    @IBOutlet weak var stockLabel: UILabel!
    
    @IBOutlet weak var addToCart: UIButton!
    
    @IBAction func addShowAlert(_ sender: Any) {
        UIAlertController.showAlert(message: "Success")
        let buyItem = CartProduct(context: StorageManager.storagsharedmanager.viewContext)
        
        buyItem.title = titleLabel.text
        buyItem.mainImage = receiveProduct.mainImage
        buyItem.price = Int16(receiveProduct.price)
        buyItem.color = receiveProduct.colors[currentColorIndexPath!.item].code
        buyItem.size = receiveProduct.sizes[currentSizeIndexPath!.item]
        buyItem.buycount = Int16(chooseCountTextField.text ?? "1") ?? 1
        buyItem.variant = Int16(stock)
        buyItem.colorName = receiveProduct.colors[currentColorIndexPath!.item].name
        buyItem.id = "\(receiveProduct.id)"
        print(buyItem)
  
        do {
            try StorageManager.storagsharedmanager.viewContext.save()
            print("trigger加入購物車")
        } catch {
            fatalError("\(error)")
        }
        
        StorageManager.storagsharedmanager.fetchBuyItem()
        NotificationCenter.default.post(name: .didUpdateBuyItemList, object: self, userInfo: nil)
        
         print("Post")
    }
    
    var stock: Int = 0
    
    @IBAction func addClickButton(_ sender: UIButton) {
       decreaseButton.isEnabled = true
       decreaseButton.alpha = 1
        
       chooseCount += 1
       chooseCountTextField.text = "\(chooseCount)"
        
        if chooseCount >= stock {
            addButton.isEnabled = false
            addButton.alpha = 0.3
        }
    }
    @IBAction func decreaseClickButton(_ sender: UIButton) {
        addButton.isEnabled = true
        addButton.alpha = 1
        
        chooseCount -= 1
        chooseCountTextField.text = "\(chooseCount)"
        
        if chooseCount <= 1 {
            decreaseButton.isEnabled = false
            decreaseButton.alpha = 0.3
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return receiveProduct.colors.count} else {
            return receiveProduct.sizes.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        if collectionView == colorCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseColorCell", for: indexPath)
        guard let imageView = cell.viewWithTag(1) as? ChooseColorCollectionViewCell else {
            return UICollectionViewCell()}
        imageView.backgroundColor = UIColor(hexString: receiveProduct.colors[indexPath.row].code)
        return cell
    } else {
    let sizecell = collectionView.dequeueReusableCell(withReuseIdentifier: "chooseSizeCell", for: indexPath)
    guard let size = sizecell.viewWithTag(2) as? ChooseSizeCollectionViewCell else {
    return UICollectionViewCell()
    }
            size.sizeLabel.text = receiveProduct.sizes[indexPath.row]
            
            size.backgroundColor  = UIColor(rgb: (r: 240, g: 240, b: 240))
    return sizecell
    }
    }
    var currentColorIndexPath: IndexPath?
    var currentSizeIndexPath: IndexPath?
    var chooseCount: Int = 1
    var chooseColor: String?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case colorCollectionView:
            let cell = colorCollectionView.cellForItem(at: indexPath)
            cell?.layer.borderColor = UIColor.black.cgColor
            cell?.layer.borderWidth = 1
            currentColorIndexPath = indexPath
            sizeCollectionView.alpha = 1
            
        case sizeCollectionView:
            if currentColorIndexPath != nil {
            let sizecell = sizeCollectionView.cellForItem(at: indexPath)
            sizecell?.layer.borderColor = UIColor.black.cgColor
            sizecell?.layer.borderWidth = 1
            currentSizeIndexPath = indexPath

            addButton.alpha = 1
            addButton.isEnabled = true
            chooseCountTextField.alpha = 1
            chooseCountTextField.isEnabled = true
            chooseCount = 1
            stockLabel.alpha = 1
            addToCart.backgroundColor = .black
            addToCart.isEnabled = true
           
            } else {
                let sizecell = sizeCollectionView.cellForItem(at: indexPath)
                sizecell?.layer.borderWidth = 0
            }
        default:
            break
        }
        guard let currentColorIndexPath = currentColorIndexPath,
            let currentSizeIndexPath = currentSizeIndexPath else {return}
        let sizeQuantity = receiveProduct.sizes.count
        let variantIndex = sizeQuantity * currentColorIndexPath.item + currentSizeIndexPath.item
        stock = receiveProduct.variants[variantIndex].stock
        chooseCountTextField.text = "\(chooseCount)"
        
        stockLabel.text = "庫存：\(stock)"
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.borderWidth = 0
            chooseCount = 1
            self.chooseCountTextField.text = "\(chooseCount)"
        } else {
            let sizecell = collectionView.cellForItem(at: indexPath)
            sizecell?.layer.borderWidth = 0
        }
    }
    
    var receiveProduct = ProductObject(
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
    
    let alphANum = "0123456789"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String)
        -> Bool {
        if textField == chooseCountTextField {
            let comSeparate = NSCharacterSet(charactersIn: alphANum).inverted
            let filtered = (string.components(separatedBy: comSeparate) as NSArray).componentsJoined(by: "")
            return string == filtered
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self

        sizeCollectionView.delegate = self
        sizeCollectionView.dataSource = self
        
        self.priceLabel.text = "NT$\(receiveProduct.price)"
        
        self.titleLabel.text = receiveProduct.title
        
        self.addButton.layer.borderWidth = 1
        self.addButton.layer.borderColor = UIColor.black.cgColor
        self.addButton.alpha = 0.3
        self.addButton.isEnabled = false
        
        self.decreaseButton.layer.borderWidth = 1
        self.decreaseButton.layer.borderColor = UIColor.black.cgColor
        self.decreaseButton.alpha = 0.3
        self.decreaseButton.isEnabled = false
        
        self.chooseCountTextField.isEnabled = false
        self.chooseCountTextField.delegate = self
        self.addToCart.backgroundColor = .gray
        self.addToCart.isEnabled = false
       
    }

    @IBAction func cancelButton(_ sender: Any) {
    }
    
}
