//
//  FieldMover.swift
//  PredatorAndPrey
//
//  Created by Александр Плешаков on 16.02.2025.
//


protocol FieldMover {
    func getRandomMovePosition(
        on field: [[Animal]],
        currentPosition: (Int, Int)
    ) -> (Int, Int)?
}

final class FieldMoverImpl: FieldMover {
    func getRandomMovePosition(
        on field: [[Animal]],
        currentPosition: (Int, Int)
    ) -> (Int, Int)? {
        guard let first = field.first, !field.isEmpty || !first.isEmpty else {
            return nil
        }
        
        var newPosition: (Int, Int)? = nil
        var positions: Set<Int> = [0, 1, 2, 3, 4, 5, 6, 7]
        
        let rowRange: Range<Int>
        if currentPosition.0 == 0 {
            rowRange = 0..<2
            positions.remove(0)
            positions.remove(1)
            positions.remove(2)
        } else if currentPosition.0 == field.count - 1 {
            rowRange = -1..<1
            positions.remove(4)
            positions.remove(5)
            positions.remove(6)
        } else {
            rowRange = -1..<2
        }
        
        let elementRange: Range<Int>
        if currentPosition.1 == 0 {
            elementRange = 0..<2
            positions.remove(0)
            positions.remove(7)
            positions.remove(6)
        } else if currentPosition.1 == field[0].count - 1 {
            elementRange = -1..<1
            positions.remove(2)
            positions.remove(3)
            positions.remove(4)
        } else {
            elementRange = -1..<2
        }
        
        while newPosition == nil && !positions.isEmpty {
            let rowOffset = Int.random(in: rowRange)
            let elementOffset = Int.random(in: elementRange)
            if rowOffset == 0 && elementOffset == 0 {
                continue
            }
            
            let row = currentPosition.0 + rowOffset
            let element = currentPosition.1 + elementOffset
            if field[row][element].type == .empty {
                newPosition = (row, element)
            } else {
                if let position = getPositionIndex(row: rowOffset, element: elementOffset) {
                    positions.remove(position)
                }
            }
        }
        
        return newPosition
    }
    
    
    
    private func getPositionIndex(row: Int, element: Int) -> Int? {
        if !(-1..<2).contains(row) || !(-1..<2).contains(element) {
            return nil
        }
        
        var position: Int? = nil
        if row == -1 {
            if element == -1 {
                position = 0
            } else if element == 0 {
                position = 1
            } else if element == 1 {
                position = 2
            }
        } else if row == 0 {
            if element == -1 {
                position = 7
            } else if element == 0 {
                position = nil
            } else if element == 1 {
                position = 3
            }
        } else if row == 1 {
            if element == -1 {
                position = 6
            } else if element == 0 {
                position = 5
            } else if element == 1 {
                position = 4
            }
        }
        
        return position
    }
}
