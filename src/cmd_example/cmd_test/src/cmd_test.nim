import "../../../cmd/go_style"

when isMainModule:
    var cmdHandler = go_style.newCmd()
    let root1 = cmdHandler.registerWithDesc("-root1", ".", "search root 1 path")
    let root2 = cmdHandler.registerWithDesc("-root2", ".", "search root 2 path")
    cmdHandler.parse()
    echo(root1[])
    echo(root2[])
