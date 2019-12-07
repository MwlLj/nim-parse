#[
## 递归遍历文件系统
## 递归策略:
##      发现是目录, 就开始进入到目录内进行递归
]#
import os

type
    CbResult* = enum
        Exit, CurLoopContinue

proc walk(root: string
    , fn: proc(parent: string, name: string, path: string): CbResult
    , dirFilter = {}
    , fileFilter = {}) =
    for (pathComponent, path) in os.walk(root):
        let (d, p) = os.splitPath(path)
        case pathComponent
        of os.PathComponent.pcFile:
            if p in fileFilter:
                continue
            else:
                case fn(d, p, path)
                of CbResult.CurLoopContinue:
                    continue
                of CbResult.Exit:
                    return
                walk(path, fn, dirFilter, fileFilter)
        of os.PathComponent.pcDir:
            if p in dirFilter:
                continue
            else:
                case fn(d, p, path)
                of CbResult.CurLoopContinue:
                    continue
                of CbResult.Exit:
                    return
