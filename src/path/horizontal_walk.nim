#[
## 递归遍历文件系统
## 递归策略:
##      首先遍历当前目录下的所有文件/目录
##      再一次遍历当前目录下的所有目录, 进行递归遍历
]#
import os

type
    CbResult* = enum
        Exit, SkipCurLoop, Continue

proc walk*(root: string
    , fn: proc(parent: string, name: string, path: string): CbResult
    , dirFilter: seq[string] = @[]
    , fileFilter: seq[string] = @[]) =
    var dirs = newSeq[string]()
    for (pathComponent, path) in os.walkDir(root):
        let (d, p) = os.splitPath(path)
        case pathComponent
        of os.PathComponent.pcFile:
            if p in fileFilter:
                continue
        of os.PathComponent.pcDir:
            if p in dirFilter:
                continue
            else:
                dirs.add(path)
        of os.PathComponent.pcLinkToDir:
            continue
        of os.PathComponent.pcLinkToFile:
            continue
        case fn(d, p, path)
        of CbResult.SkipCurLoop:
            continue
        of CbResult.Exit:
            return
        of CbResult.Continue:
            continue
    for dir in dirs:
        walk(dir, fn, dirFilter, fileFilter)
