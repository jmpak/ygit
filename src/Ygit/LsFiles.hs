module Ygit.LsFiles (
  lsFiles
) where

import qualified Data.ByteString.Lazy as BS
import System.Directory
import System.FilePath.Posix
import Data.Binary.Get
import Data.Word

lsFiles :: [String] -> IO ()
lsFiles args = do 
      indexFileContent <- indexFile
      print $ runGet readHeader indexFileContent

indexFile :: IO BS.ByteString
indexFile = do
  cwd <- getCurrentDirectory
  let filePath = (cwd </> ".git" </> "index")
  BS.readFile filePath

readHeader :: Get BS.ByteString
readHeader = do 
  d <- getWord8
  i <- getWord8
  r <- getWord8
  c <- getWord8
  return $ BS.pack [d,i,r,c]