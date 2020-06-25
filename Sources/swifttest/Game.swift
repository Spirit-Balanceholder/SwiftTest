import Foundation

let queue = DispatchQueue(label: "game")

class Game
{
    let map = GameField();

    func start()
    {
        print("Game Started, Enter the dimensions of the gamefield\nor leave empty for standard 15x15")
        var dimensions = readLine();
        while (!map.generate(Size: dimensions!)){
            print("invalid input! please input X by Y dimensions")
            dimensions = readLine()
        }
        readLine()
        ShellManager.ClearConsole()
        

        update();

        readLine()
    }

    func update ()
    {
        map.draw()

        queue.asyncAfter(deadline: .now() + .milliseconds(200), execute: self.update)
    }
}