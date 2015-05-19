import System.Environment
import System.Directory
import Data.List
import System.FilePath.Posix
import qualified System.FilePath.Find as Find
import System.FilePath.Find hiding (find)
import Control.Monad
import Data.Functor
import qualified System.Posix.Files as Files

main :: IO ()
main = do
  args <- getArgs
  cwd <- getCurrentDirectory
  let gitObjectsDir = cwd </> ".git/objects"
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
    unwords [show count, "objects,", show size, "kilobytes"]

countObjects :: FilePath -> IO CountObjects
countObjects gitDir = do
      files <- getAllObjects gitDir
      size <- sizeOf files
      return (CountObjects (length files) size)

getAllObjects :: FilePath -> IO [FilePath]
getAllObjects dir = Find.find (return True) (fileType ==? RegularFile &&? extension /=? ".idx" &&? extension /=? ".pack" &&? fileName /=? "packs") dir

sizeOf :: [FilePath] -> IO Int
sizeOf files = do
    sizes <- mapM sizeFor files
    return $ foldl (+) 0 sizes

sizeFor :: FilePath -> IO Int
sizeFor file = (fromIntegral . toInteger . Files.fileSize) <$> (Files.getFileStatus file) 
