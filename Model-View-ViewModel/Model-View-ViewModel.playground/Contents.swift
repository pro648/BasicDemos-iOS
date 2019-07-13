// 详细介绍： https://github.com/pro648/tips/wiki/MVVM%E8%AE%BE%E8%AE%A1%E6%A8%A1%E5%BC%8F

import PlaygroundSupport
import UIKit

// MARK: - Model
public class Pet {
    public enum Rarity {
        case common
        case uncommon
        case rare
        case veryRare
    }
    
    public let name: String
    public let birthday: Date
    public let rarity: Rarity
    public let image: UIImage
    
    public init(name: String,
                birthday: Date,
                rarity: Rarity,
                image: UIImage) {
        self.name = name
        self.birthday = birthday
        self.rarity = rarity
        self.image = image
    }
}

// MARK: - ViewModel
public class PetViewModel {
    
    // 创建两个属性，并在初始化方法中设值。
    private let pet: Pet
    private let calendar: Calendar
    
    public init(pet: Pet) {
        self.pet = pet
        self.calendar = Calendar(identifier: .gregorian)
    }
    
    // 声明 name 和 image 为计算属性。
    public var name: String {
        return pet.name
    }
    
    public var image: UIImage {
        return pet.image
    }
    
    // 计算属性转换后，将可以使用显示。
    public var ageText: String {
        let today = calendar.startOfDay(for: Date())
        let birthday = calendar.startOfDay(for: pet.birthday)
        let components = calendar.dateComponents([.year],
                                                 from: birthday,
                                                 to: today)
        let age = components.year!
        return "\(age) years old"
    }
    
    // 根据 rarity 决定价格。
    public var adoptionFeeText: String {
        switch pet.rarity {
        case .common:
            return "$50.00"
        case .uncommon:
            return "75.00"
        case .rare:
            return "150.00"
        case .veryRare:
            return "$500.00"
        }
    }
}

extension PetViewModel {
    public func configure(_ view: PetView) {
        view.nameLabel.text = name
        view.imageView.image = image
        view.ageLabel.text = ageText
        view.adoptionFeeLabel.text = adoptionFeeText
    }
}

// MARK: - View
public class PetView: UIView {
    public let imageView: UIImageView
    public let nameLabel: UILabel
    public let ageLabel: UILabel
    public let adoptionFeeLabel: UILabel
    
    public override init(frame: CGRect) {
        var childFrame = CGRect(x: 0,
                                y: 16,
                                width: frame.width,
                                height: frame.height / 2)
        imageView = UIImageView(frame: childFrame)
        imageView.contentMode = .scaleAspectFit
        
        childFrame.origin.y += childFrame.height + 16
        childFrame.size.height = 30
        nameLabel = UILabel(frame: childFrame)
        nameLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        ageLabel = UILabel(frame: childFrame)
        ageLabel.textAlignment = .center
        
        childFrame.origin.y += childFrame.height
        adoptionFeeLabel = UILabel(frame: childFrame)
        adoptionFeeLabel.textAlignment = .center
        
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(adoptionFeeLabel)
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) is not supported")
    }
}

// MARK: - Example
let birthday = Date(timeIntervalSinceNow: (-3 * 86400 * 366))
let image = UIImage(named: "direwolf")!
let direwolf = Pet(name: "Direwolf",
                 birthday: birthday,
                 rarity: .veryRare,
                 image: image)

// 使用 direwolf 创建 viewModel
let viewModel = PetViewModel(pet: direwolf)

let frame = CGRect(x: 0,
                   y: 0,
                   width: 300,
                   height: 420)
let view = PetView(frame: frame)

// 使用 viewModel 直接显示
//view.nameLabel.text = viewModel.name
//view.imageView.image = viewModel.image
//view.ageLabel.text = viewModel.ageText
//view.adoptionFeeLabel.text = viewModel.adoptionFeeText

viewModel.configure(view)

PlaygroundPage.current.liveView = view
