module Ygit.HashObject (
  hashObject
) where

import Control.Monad
import Data.Functor
import Crypto.Hash.SHA1 (hash)
import qualified Data.ByteString as Strict
import qualified Data.ByteString.Char8 as Char8
import Text.Printf (printf)
import qualified System.Posix.Files as Files

hashObject :: [String] -> IO ()
hashObject = mapM_ ((fmap toHex) . hashFile >=> print)

header :: FilePath -> IO Strict.ByteString
header =  (fmap (\f -> Char8.pack $ "blob " ++ show f ++ "\0" )) . sizeFor

toHex :: Strict.ByteString -> String
toHex bytes = Strict.unpack bytes >>= printf "%02x"

hashFile :: FilePath -> IO Strict.ByteString
hashFile f = do
        fileHeader <- header f
        fileContent <- Strict.readFile f
        return $ hash $ (Strict.append fileHeader fileContent)

sizeFor :: FilePath -> IO Int
sizeFor file = (fromIntegral . toInteger . Files.fileSize) <$> (Files.getFileStatus file)
