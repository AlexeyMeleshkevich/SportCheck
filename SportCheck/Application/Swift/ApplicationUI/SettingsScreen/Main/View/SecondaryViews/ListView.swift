import UIKit

class ListView: UIScrollView {
    
    private let contentView = UIView()
    
    private var cellsArray: [UIView] = []
    private var separatorsArray: [UIView] = []
    
    private var baseCellHeight: CGFloat = 50
    private var separatorColor = UIColor.darkGray
    private var separatorRatio = (9, 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isScrollEnabled = true
        
        setupContentView()
    }
    
    convenience init(cellHeight: CGFloat) {
        self.init()
        
        self.baseCellHeight = cellHeight
        isScrollEnabled = true
        
        setupContentView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setSeparatorRation(_ numerator: Int, to denominator: Int) {
        separatorRatio.0 = numerator
        separatorRatio.1 = denominator
        
        guard !separatorsArray.isEmpty else { return }
        
        for separator in separatorsArray {
            separator.removeConstraints(separator.constraints)
            
            activateSeparatorConstraints(separator)
        }
    }
    
    public func setCellHeight(_ height: Int) {
        baseCellHeight = CGFloat(height)
        
        guard !cellsArray.isEmpty else { return }
        
        for cell in cellsArray {
            cell.removeConstraints(cell.constraints)
            activateBaseViewConstraints(cell)
        }
    }
    
    public func setSeparatorColor(_ color: UIColor) {
        separatorColor = color
        
        guard !separatorsArray.isEmpty else { return }
        
        for separator in separatorsArray {
            separator.backgroundColor = separatorColor
        }
    }
    
    public func addCell(view: UIView) {
        let cell = getBaseView().pinnedWithSubview(add: true, subview: view, leading: getLeastWidthFromRation(separatorRatio.0, to: separatorRatio.1), trailing: -20)
        
        cellsArray.append(cell)
    }
    
    private func setupContentView() {
        let contentViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        
        contentView.frame = contentViewFrame
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 500),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    private func getContentSize() -> CGSize {
        let defaultWidth = frame.width
        let defaultHeight = frame.height * 2
        var tempHeight: CGFloat = 0.0
        
        guard !cellsArray.isEmpty else { return CGSize(width: defaultWidth, height: defaultHeight) }
        for cell in cellsArray {
            tempHeight += cell.frame.height
        }
        
        return CGSize(width: defaultWidth, height: 100 + defaultHeight)
    }
    
    private func getBaseView() -> UIView {
        let baseView = UIView()
        
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        activateBaseViewConstraints(baseView)
        baseView.pinViewToBottom(viewToPin: getSeparatorView())
        
        return baseView
    }
    
    private func getSeparatorView() -> UIView {
        let separator = UIView()
        
        separator.backgroundColor = separatorColor
        
        contentView.addSubview(separator)
        
        separatorsArray.append(separator)
        
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        activateSeparatorConstraints(separator)
        
        return separator
    }
    
    private func activateBaseViewConstraints(_ baseView: UIView) {
        NSLayoutConstraint.activate([
            baseView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            baseView.heightAnchor.constraint(equalToConstant: baseCellHeight),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            baseView.topAnchor.constraint(equalTo: cellsArray.last?.bottomAnchor ?? contentView.topAnchor, constant: 2)
        ])
    }
    
    private func activateSeparatorConstraints(_ separator: UIView) {
        let separatorWidth = getWidthFromRatio(separatorRatio.0, to: separatorRatio.1)
        
        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 0.3),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.widthAnchor.constraint(equalToConstant: separatorWidth)
        ])
    }
}
