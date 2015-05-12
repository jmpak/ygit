import System.Environment
import System.Directory
import Data.List
import System.FilePath.Posix
import qualified System.FilePath.Find as Find
import System.FilePath.Find hiding (find)
import Control.Monad
import qualified System.Posix.Files as Files

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
  size <- sizeOf files
  return (length files, size)

formatCountObjects :: (Int, Int) -> String
formatCountObjects (count, size) = unwords [show count, "objects,", show size, "kilobytes"]

getAllObjects :: FilePath -> IO [FilePath]
getAllObjects dir = Find.find (return True) (fileType ==? RegularFile) dir

sizeOf :: [FilePath] -> IO Int
sizeOf files = 
              do
                sizes <- (mapM 
                          ((liftM (fromIntegral . toInteger . Files.fileSize)) . Files.getFileStatus) 
                          files)
                return (foldl (\acc a -> acc + a) 0 sizes)
  -- foldM f 0 files
  -- where
  --   f acc file = do
  --     fs <- Files.getFileStatus file
  --     return (acc + ((fromIntegral . toInteger . Files.fileSize) fs))

