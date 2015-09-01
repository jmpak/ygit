import System.Environment
import System.Directory
import System.FilePath.Posix
import Ygit.CountObjects
import Ygit.HashObject
import Ygit.LsFiles

main :: IO ()
main = do
  args <- getArgs
  case args of
    ("count-objects":cmdArgs) -> callWithObjectsDir $ countObjects cmdArgs
    ("hash-object":cmdArgs) -> hashObject cmdArgs
    ("ls-files":cmdArgs) -> lsFiles cmdArgs

callWithObjectsDir :: (FilePath -> IO ()) -> IO ()
callWithObjectsDir f = do
  cwd <- getCurrentDirectory
  let gitObjectsDir = cwd </> ".git/objects"
  directoryExist <- doesDirectoryExist gitObjectsDir
  case directoryExist of
    True -> f gitObjectsDir
    False -> 
      print "fatal: Not a git repository (or any of the parent directories): .git"
