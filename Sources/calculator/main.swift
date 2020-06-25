import Dispatch
import swifttest

//let game = Game()

ShellManager.ClearConsole()

//game.start()
// readLine()

let calc = Calculator()
var success = false

while (!success){
    print("Please insert formula")
    if let input = readLine() {
        if let result = calc.tryParseAndSolveFormula(from: input) {
            success = true;
            print("Result = \(result)")            
        }
    }
}