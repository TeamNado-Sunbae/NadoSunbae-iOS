//
//  ClassroomMainSection.swift
//  NadoSunbae
//
//  Created by EUNJU on 2022/08/14.
//

import RxDataSources

enum ClassroomMainSection {
    case imageSection([ClassroomMainSectionItem])
    case reviewPostSection([ClassroomMainSectionItem])
}

enum ClassroomMainSectionItem {
    case imageCell
    case reviewPostCell(ReviewPostCellReactor)
}

// MARK: - ClassroomMainSection
extension ClassroomMainSection: SectionModelType {
    
    typealias Item = ClassroomMainSectionItem
    
    var items: [Item] {
        switch self {
        case .imageSection(let items):
            return items
        case .reviewPostSection(let items):
            return items
        }
    }
    
    init(original: ClassroomMainSection, items: [ClassroomMainSectionItem]) {
        switch original {
        case .imageSection:
            self = .imageSection(items)
        case .reviewPostSection:
            self = .reviewPostSection(items)
        }
    }
}
