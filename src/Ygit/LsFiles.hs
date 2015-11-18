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

readHeader :: Get Word32
readHeader = do 
  dirc <- getWord32be
  version <- getWord32be
  numberOfFiles <- getWord32be
  return $ numberOfFiles