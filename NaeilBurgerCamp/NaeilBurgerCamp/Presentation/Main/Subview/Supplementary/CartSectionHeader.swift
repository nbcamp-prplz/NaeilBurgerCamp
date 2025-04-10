import UIKit
import SnapKit

final class CartSectionHeader: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = String(.orderDetails)
        label.font = .nanumSquareRound(ofSize: 15, weight: .bold)
        label.textColor = .bcPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CartSectionHeader {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        addSubviews(titleLabel)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
    }
}

extension CartSectionHeader: BCReusableView {
    static var identifier: String {
        "CartSectionHeader"
    }

    static var reusableViewType: ReusableViewType {
        .header
    }
}
