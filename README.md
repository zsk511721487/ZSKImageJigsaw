# ZSKImageJigsaw

```
let showVC = ZSKImageJigsawVC()
        showVC.modalPresentationStyle = .fullScreen
        showVC.images = [UIImage(named: "gougou1")!,UIImage(named: "maomao1")!,UIImage(named: "maomao2")!,UIImage(named: "maomao2")!,UIImage(named: "maomao3")!,UIImage(named: "maomao3")!,UIImage(named: "maomao3")!,UIImage(named: "maomao3")!,UIImage(named: "maomao3")!]
        showVC.delegate  = self
        self.present(showVC, animated: true, completion: nil)
```

## delegate

```
extension ViewController:ZSKImageJigsawDelegate {
    func imageJigsaw(imageJigsaw: UIViewController, image: UIImage) {
        self.imageVIew.image = image
    }
}
```
