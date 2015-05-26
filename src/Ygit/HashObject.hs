module Ygit.HashObject (
  hashObject
) where

import Control.Monad
import Data.Functor

hashObject :: [String] -> IO ()
hashObject = mapM_ (hashOfFile >=> print)

hashOfFile :: String -> IO String
hashOfFile _ = return "asdfadsf"

