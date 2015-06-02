module Ygit.HashObject (
  hashObject
) where

import Control.Monad
import Data.Functor
import Crypto.Hash.SHA1 (hash)
import qualified Data.ByteString as ByteString
import qualified Data.ByteString.Char8 as Char8
import Text.Printf (printf)
import qualified System.Posix.Files as Files

hashObject :: [String] -> IO ()
hashObject ("-w":files) = mapM_ (hashFile >=> saveAndPrint) files
hashObject files = mapM_ (hashFile >=> print . fst) files

saveAndPrint :: (ByteString.ByteString, String) -> IO ()
saveAndPrint (content, h) = do
  ByteString.writeFile "~/Desktop/test" content
  print h

header :: FilePath -> IO ByteString.ByteString
header =  (fmap (\f -> Char8.pack $ "blob " ++ show f ++ "\0" )) . sizeFor

toHex :: ByteString.ByteString -> String
toHex bytes = ByteString.unpack bytes >>= printf "%02x"

hashFile :: FilePath -> IO (ByteString.ByteString, String)
hashFile f = do
        fileHeader <- header f
        fileContent <- ByteString.readFile f
        let blobContent = ByteString.append fileHeader fileContent
        return $ (blobContent, toHex $ hash blobContent)

sizeFor :: FilePath -> IO Int
sizeFor file = (fromIntegral . toInteger . Files.fileSize) <$> (Files.getFileStatus file)
