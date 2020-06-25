import Foundation

public class ShellManager {
    public static func ClearConsole()
    {
        let Clear = Process()
        Clear.executableURL = URL(fileURLWithPath: "/usr/bin/clear")
        do{
            try Clear.run()
        } catch {
            print("Could not execute ClearConsole");
        }
        Clear.waitUntilExit();
    }
}