module Filter where

import Text.Pandoc.JSON
import Text.Pandoc.Definition
import Text.Pandoc.Walk
import System.Process
import Data.List

filterMain = toJSONFilter runfilter

runfilter :: Pandoc -> IO Pandoc
runfilter x = do y <- (walkM runcodeblock) x
                 (walkM runcode) y


hasAttr :: [(String,String)] -> (String,String) -> Bool
hasAttr [] _ = False
hasAttr list (a,b)
  | Just b <- lookup a list = True
  | otherwise = False

newblock :: Attr -> String -> Block
newblock (id, classes, namevals) contents
  | hasAttr namevals ("style", "code") =
    CodeBlock(id, classes, (namevals \\ [(("style", "code"))])) contents
  | otherwise = Plain [Str contents]

newinline :: Attr -> String -> Inline
newinline (id, classes, namevals) contents
  | hasAttr namevals ("style", "code") =
    Code(id, classes, (namevals \\ [(("style", "code"))])) contents
  | otherwise = Str contents

runcommand :: String -> String -> IO String
runcommand kind script
  | kind == "bash" = (readProcess "bash" [ "-c", script ] [])
  | kind == "sh" = (readProcess "sh" [ "-c", script ] [])
  | kind == "nodep" = (readProcess "node" [ "-p", script ] [])
  | kind == "nodee" = (readProcess "node" [ "-e", script ] [])
  | kind == "node" = (readProcess "node" [ "-p", script ] [])
  | otherwise = return script

runcodeblock :: Block -> IO Block
runcodeblock cb@(CodeBlock attr@(id, classes, namevals) contents)
  | Just kind <- lookup "run" namevals = return . newblock attr =<< runcommand kind contents
  | otherwise = return cb
runcodeblock x = return x

runcode :: Inline -> IO Inline
runcode cb@(Code attr@(id, classes, namevals) contents)
  | Just kind <- lookup "run" namevals = return . newinline attr =<< runcommand kind contents
  | otherwise = return cb
runcode x = return x
