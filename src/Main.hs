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
  cwd <- getCurrentDirectory
  let gitObjectsDir = cwd </> ".git/objects"
  countObjects gitObjectsDir >>= print
  directoryExist <- doesDirectoryExist gitObjectsDir
  case directoryExist of
    True -> 
      case args of
        ("count-objects":as) -> countObjects gitObjectsDir >>= print
        _ -> print "Yet to be implemented"
    False -> 
      print "fatal: Not a git repository (or any of the parent directories): .git"
   
data CountObjects = CountObjects Int Int deriving (Eq)
instance Show CountObjects where
  show (CountObjects count size) = 
    unwords [show count, "objects,", show size, "kylobytes"]

countObjects :: FilePath -> IO CountObjects
countObjects gitDir = do
      files <- getAllObjects gitDir
      size <- sizeOf files
      return (CountObjects (length files) size)

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

