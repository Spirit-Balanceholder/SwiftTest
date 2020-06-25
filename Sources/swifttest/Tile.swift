

struct Tile {
    init?(Symbol symbol:String = ".", Map gamefield: GameField, Coordinates position: Coordinates)
    {
        guard (symbol.count == 1) else {
            return nil
        }
        self.tileSymbol = symbol
        self.map=gamefield
        self.position = position
    }
    
    init?(Symbol symbol:String = ".", Map gamefield: GameField, Xposition x : Int, Yposiion y : Int)
    {
        guard (symbol.count == 1) else {
            return nil
        }
        self.tileSymbol = symbol
        self.map=gamefield
        self.position = Coordinates(x: x, y: y)
    }

    var position : Coordinates
    var tileSymbol : String = "."
    unowned var map: GameField

    var up : Tile?{
        get {map[position.x, position.y - 1]}
        set {map[position.x, position.y - 1] = newValue}
    }
    var down : Tile? {
        get {map[position.x, position.y + 1]}
        set {map[position.x, position.y + 1] = newValue}
    }
    var left : Tile? {
        get {map[position.x, position.y + 1]}
        set {map[position.x, position.y + 1] = newValue}
    }
    var right : Tile? {
        get {map[position.x, position.y + 1]}
        set {map[position.x, position.y + 1] = newValue}
    }
}