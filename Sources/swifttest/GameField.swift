struct FieldSize {
    var x = 0
    var y = 0
}

struct Coordinates: Hashable {
    var x: Int
    var y: Int

    private init() {
        self.x = -1
        self.y = -1
    }

    public init(x: Int, y: Int) {
        assert(x >= 0, "Invalid X")
        assert(y >= 0, "Invalid Y")

        self.x = x
        self.y = y
    }
    
    static let invalid = Coordinates()
}

class GameField {
    private var tiles = [[Tile]]()

    subscript(x: Int, y: Int) -> Tile? {
        get {
            tiles[x][y]
        }
        set {
            if (newValue != nil) {
                tiles[x][y] = newValue!
            }
        }
    }

    subscript(Coords: Coordinates) -> Tile? {
        get {
            tiles[Coords.x][Coords.y]
        }
        set {
            if (newValue != nil) {
                tiles[Coords.x][Coords.y] = newValue!
            }

            if Coords == .invalid {

            }
        }
    }

    enum ParseTypes {
        case number
        case other
    }
    
    var value = 0
    var size = FieldSize()

    func generate (Size size : String) -> Bool
    {
        if (size == ""){
            return generate()
        }

        var x : Int? = 0
        var y : Int? = 0
        var parseString = ""
        var parseType = ParseTypes.number

        for char in size {
            switch parseType {
            case .number:
                if (char.isNumber){              
                    parseString += String(char)
                }
                else {
                    if (parseString == ""){
                        return false
                    }
                    parseType = ParseTypes.other;
                    if(x == 0){
                        x = Int(parseString)!
                    }
                }
            default:
                if (char.isNumber){
                    parseString = String(char);
                    parseType = ParseTypes.number
                }
            }
        }
        y = Int(parseString)!

        if (y == nil || y == 0){
            return false
        }
        
        return generate(X: x!, Y: y!);
    }
    
    func generate (X x : Int = 15, Y y : Int = 15) -> Bool
    {
        size.x = x;
        size.y = y;
        print("generating gamefield of x: \(x) by y: \(y)")

        //var tiles = [[Tile]](repeating: [Tile](repeating: Tile(X: 0, Y: 0, Map: self)!, count: y), count: x)
        
        //tiles[0][0].generateField(Size: size)

        //self.tiles = tiles
        return true
    }

    func draw()
    {

        //let mapstring = tiles.map{$0.map{$0.tileSymbol}}.joined().joined(separator: "\n")

        //print(mapstring);
        

        /*
        var row : String;
        print("\u{1B}[\(0);\(0)H")
        for _ in 0...size.x {
            row = "";
            for _ in 0...size.y {
                row+=String(value)
            }
            print(row)
        }
        value+=1
        */
    }
}
