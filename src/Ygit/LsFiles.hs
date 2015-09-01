module Ygit.LsFiles (
  lsFiles
) where

lsFiles :: [String] -> IO ()
lsFiles args = print args
