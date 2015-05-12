import System.Environment
import System.Directory
import Data.List
import System.FilePath.Posix
import qualified System.FilePath.Find as Find
import System.FilePath.Find hiding (find)

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("count-objects":as) -> countObjects
    _ -> putStrLn "Yet to be implemented"

countObjects :: IO ()
countObjects = do
  cwd <- getCurrentDirectory
  let gitObjectsDir = cwd </> ".git/objects"
  directoryExists <- doesDirectoryExist gitObjectsDir
  if directoryExists
  then do
    countAndSize <- countObjectsAndSize gitObjectsDir
    putStrLn . formatCountObjects $ countAndSize
  else 
    putStrLn "fatal: Not a git repository (or any of the parent directories): .git"

countObjectsAndSize :: FilePath -> IO (Int, Int)
countObjectsAndSize objectsDir = do
  files <- getAllObjects objectsDir
  putStrLn $ show files
  return (length files, 12)

formatCountObjects :: (Int, Int) -> String
formatCountObjects (count, size) = unwords [show count, "objects,", show size, "kilobytes"]

getAllObjects :: FilePath -> IO [FilePath]
getAllObjects dir = Find.find (return True) (fileType ==? RegularFile) dir


