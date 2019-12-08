#[
## 递归遍历文件系统
## 递归策略:
##      发现是目录, 就开始进入到目录内进行递归
]#
import os

type
    CbResult* = enum
        Exit, SkipCurLoop, Continue

proc walk*(root: string
    , fn: proc(parent: string, name: string, path: string): CbResult
    , dirFilter: seq[string] = @[]
    , fileFilter: seq[string] = @[]) =
    for (pathComponent, path) in os.walkDir(root):
        let (d, p) = os.splitPath(path)
        case pathComponent
        of os.PathComponent.pcFile:
            if p in fileFilter:
                continue
            else:
                case fn(d, p, path)
                of CbResult.SkipCurLoop:
                    continue
                of CbResult.Exit:
                    return
                of CbResult.Continue:
                    continue
        of os.PathComponent.pcDir:
            if p in dirFilter:
                continue
            else:
                case fn(d, p, path)
                of CbResult.SkipCurLoop:
                    continue
                of CbResult.Exit:
                    return
                of CbResult.Continue:
                    walk(path, fn, dirFilter, fileFilter)
        of os.PathComponent.pcLinkToFile:
            continue
        of os.PathComponent.pcLinkToDir:
            continue
