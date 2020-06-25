import Foundation

typealias biCalculation = (Double, Double) -> Double

enum ExpressionTypes {
    case number
    case biCalculation
}

protocol ArithmeticExpression {
    func calculate() throws -> Double
    mutating func add (NewNode newNode : ArithmeticExpression) throws -> ArithmeticExpression
    var left : ArithmeticExpression? {get}
    var right : ArithmeticExpression? {get}
    var operation : (Int, biCalculation)? {get}
    var type : ExpressionTypes {get}
    var priority : Int {get}
}

extension Double : ArithmeticExpression {
    func calculate() -> Double {
        return self
    }

    func add(NewNode newNode : ArithmeticExpression) throws -> ArithmeticExpression {
        throw CustomErrors.InvalidOperation("Cannot add subnode to a double node")
    }

    enum CustomErrors: Error {
        case InvalidOperation(String)
    }

    var operation: (Int, biCalculation)? {get {return nil}}
    var left : ArithmeticExpression? {get {return nil}}
    var right : ArithmeticExpression? {get {return nil}}
    var type : ExpressionTypes {get {return ExpressionTypes.number}}
    var priority: Int {get {return Int.max}}
}

struct BiCalculation : ArithmeticExpression {
    init (Operation operation : @escaping biCalculation, Priority priority : Int, Left left : ArithmeticExpression?, Right right : ArithmeticExpression?) {
        self.left = left;
        self.right = right;
        self.operation = (priority, operation)
    }

    func calculate() throws -> Double {
        return try operation!.1(left!.calculate(), right!.calculate())
    }

    mutating func add(NewNode newNode : ArithmeticExpression) throws -> ArithmeticExpression {
        if (newNode.priority <= self.priority){
            return BiCalculation(Operation: newNode.operation!.1, Priority: newNode.operation!.0, Left: self, Right: newNode.right )
        }
        if self.right!.type == ExpressionTypes.number {
            self.right = newNode
        }
        else {
            try self.right = self.right?.add(NewNode: newNode)
        }
        
        return self
    }

    var left : ArithmeticExpression?
    var right : ArithmeticExpression?
    var operation : (Int, biCalculation)?
    var priority : Int {get {return operation!.0}} 
    var type : ExpressionTypes {get {return ExpressionTypes.biCalculation}}
}

public class Calculator
{
    public init ()
    {
        KnownCalculation.updateValue((pow,3), forKey: "^")
        KnownCalculation.updateValue((*,2), forKey: "*")
        KnownCalculation.updateValue((/,2), forKey: "/")
        KnownCalculation.updateValue((+,1), forKey: "+")
        KnownCalculation.updateValue((-,1), forKey: "-")
    }

    var KnownCalculation = [String:(biCalculation, Int)]()

    enum ParseTypes {
        case Numbers
        case Operators
        case Brackets
        case Unknown
    }

    public func tryParseAndSolveFormula (from input : String) -> Double?
    {
        let input = input.replacingOccurrences(of: ",", with: ".")
        if let SegmentedInput = Segment(Input: input)
        {
            var LastNumberAdded : Double?
            var RootExpression : ArithmeticExpression?
            var OperatorBuffer : (biCalculation, Int)?
            var PriorityOffset = 0
            var BracketStart = false

            for segment in SegmentedInput {
                switch (segment.0) {
                    case ParseTypes.Numbers : 
                        if (OperatorBuffer != nil) {
                            if (RootExpression == nil){
                                RootExpression = BiCalculation(Operation: OperatorBuffer!.0, Priority: (OperatorBuffer!.1+PriorityOffset), Left: LastNumberAdded!, Right: Double(segment.1)!)
                            }
                            else {
                                do {
                                    try RootExpression = RootExpression?.add(NewNode: BiCalculation(Operation: OperatorBuffer!.0, Priority: (OperatorBuffer!.1+PriorityOffset), Left: LastNumberAdded!, Right: Double(segment.1)!))
                                }
                                catch{
                                    print (error)
                                }
                            }
                            LastNumberAdded = Double(segment.1)
                        }
                        else {
                            LastNumberAdded = Double(segment.1)
                        }
                        break;
                    case ParseTypes.Operators : 
                        OperatorBuffer = KnownCalculation[segment.1]
                        break;
                    case ParseTypes.Brackets : 
                        if (segment.1 == "(") {
                            BracketStart = true
                        }
                        else {
                            PriorityOffset-=10
                        }
                        continue
                    default:
                        break;
                }
                if (BracketStart) {
                    PriorityOffset+=10
                    BracketStart = false
                }
            }

            do{
                return try RootExpression?.calculate()
            }
            catch {
                return nil
            }
        }
        return nil
    }

    private func Segment (Input input : String) -> [(ParseTypes, String)]?
    {
        var CurrentlyParsing = ParseTypes.Unknown
        var CurrentSegment = ""
        var SegmentedInput = [(ParseTypes, String)]()
        var DecimalPoint = false;

        for char in input
        {
            if char.isNumber || char == "."
            {

                if (char == ".") {
                    if (DecimalPoint){
                        return nil
                    }
                    DecimalPoint = true
                }
                if CurrentlyParsing == ParseTypes.Numbers{
                    CurrentSegment += String(char)
                }
                else {
                    if CurrentSegment != "" {
                        SegmentedInput.append((CurrentlyParsing, CurrentSegment))
                    }
                    CurrentlyParsing = ParseTypes.Numbers
                    CurrentSegment = String(char)
                }
                continue
            }

            if CurrentSegment != "" {
                SegmentedInput.append((CurrentlyParsing, CurrentSegment))
                CurrentSegment = ""
                DecimalPoint = false
            }

            if char.isWhitespace{
                continue
            }

            if char == "(" || char == ")" {
                SegmentedInput.append((ParseTypes.Brackets, String(char)))
                continue
            }

            if KnownCalculation.keys.contains(String(char)) {
                SegmentedInput.append((ParseTypes.Operators, String(char)))
                continue
            }
            else {
                return nil
            }
        }

        if CurrentSegment != "" {
            SegmentedInput.append((CurrentlyParsing, CurrentSegment))
            CurrentSegment = ""
            DecimalPoint = false
        }

        return SegmentedInput
    }
}