#!/usr/bin/env runhaskell

import Text.Pandoc.JSON
import Text.Pandoc.Definition
import System.Process

main = toJSONFilter runcmd


runcmd :: Block -> IO Block
runcmd cb@(CodeBlock (id, classes, namevals) contents)
  | classes == ["run","bash"]  =
    return . CodeBlock ("", [], []) =<< (readProcess "bash" [ "-c", contents ] [])
  | classes == ["run", "node"]  =
    return . CodeBlock ("", [], []) =<< (readProcess "node" [ "-p", contents ] [])
  | otherwise = return cb
