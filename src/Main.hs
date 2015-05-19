import System.Environment
import System.Directory
import System.FilePath.Posix
import Ygit.CountObjects

main :: IO ()
main = do
  args <- getArgs
  cwd <- getCurrentDirectory
  let gitObjectsDir = cwd </> ".git/objects"
  directoryExist <- doesDirectoryExist gitObjectsDir
  case directoryExist of
    True -> 
      case args of
        ("count-objects":cmdArgs) -> countObjects gitObjectsDir >>= print
        -- ("hash-object":cmdArgs) -> hashObject cmdArgs gitObjectsDir >>= print
        _ -> print "Yet to be implemented"
    False -> 
      print "fatal: Not a git repository (or any of the parent directories): .git"

