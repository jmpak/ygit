module Ygit.CountObjects (
  countObjects
) where

import Data.List
import qualified System.FilePath.Find as Find
import System.FilePath.Find hiding (find)
import Data.Functor
import qualified System.Posix.Files as Files

data CountObjects = CountObjects Int Int deriving (Eq)
instance Show CountObjects where
  show (CountObjects count size) = 
    unwords [show count, "objects,", show size, "kilobytes"]

countObjects :: [String] -> FilePath -> IO ()

countObjects (_:_) _ = print "print usage yet to be implemented"
countObjects [] gitDir = do
      files <- getAllObjects gitDir
      size <- sizeOf files
      print (CountObjects (length files) (round $ fromIntegral size / 1024))

getAllObjects :: FilePath -> IO [FilePath]
getAllObjects dir = Find.find (return True) (fileType ==? RegularFile &&? extension /=? ".idx" &&? extension /=? ".pack" &&? fileName /=? "packs") dir

sizeOf :: [FilePath] -> IO Int
sizeOf files = do
    sizes <- mapM sizeFor files
    return $ foldl (+) 0 sizes

sizeFor :: FilePath -> IO Int
sizeFor file = (fromIntegral . toInteger . Files.fileSize) <$> (Files.getFileStatus file) 

