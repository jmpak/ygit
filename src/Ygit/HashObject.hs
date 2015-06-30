module Ygit.HashObject (
  hashObject
) where

import Control.Monad
import Data.Functor
import Crypto.Hash.SHA1 (hash)
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Char8 as C
import Text.Printf (printf)
import qualified System.Posix.Files as F
import System.Environment
import System.Directory
import System.FilePath.Posix
import qualified Codec.Compression.Zlib as Z

hashObject :: [String] -> IO ()
hashObject ("-w":files) = mapM_ (hashFile >=> saveAndPrint) files
hashObject files = mapM_ (hashFile >=> print . snd) files

saveAndPrint :: (C.ByteString, String) -> IO ()
saveAndPrint (content, h) = do
  cwd <- getCurrentDirectory
  let dir = (cwd </> ".git/objects" </> (take 2 h))
  createDirectoryIfMissing True dir
  let filepath = dir </> (drop 2 h)
  exists <- doesFileExist filepath
  if not exists
  then 
    L.writeFile filepath $ (Z.compress . L.fromChunks) [content]
  else 
    return ()
  print h

header :: FilePath -> IO C.ByteString
header =  (fmap (\f -> C.pack $ "blob " ++ show f ++ "\0" )) . sizeFor

toHex :: C.ByteString -> String
toHex bytes = C.unpack bytes >>= printf "%02x"

hashFile :: FilePath -> IO (C.ByteString, String)
hashFile f = do
        fileHeader <- header f
        fileContent <- C.readFile f
        let blobContent = C.append fileHeader fileContent
        return $ (blobContent, toHex $ hash blobContent)

sizeFor :: FilePath -> IO Int
sizeFor file = (fromIntegral . toInteger . F.fileSize) <$> (F.getFileStatus file)
