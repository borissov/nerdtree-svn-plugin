
if exists("g:loaded_nerdtree_svn_menuitem")
    finish
endif
let g:loaded_nerdtree_svn_menuitem = 1


function! NERDTreeSvnDirectoryCheck()
    let curNode = g:NERDTreeFileNode.GetSelected()
    return curNode.path.isDirectory
endfunction


call NERDTreeAddMenuItem({
            \ 'text': '(w)svn commit',
            \ 'shortcut': 'w',
            \ 'callback': 'NERDTreeSvnCommit',
            \ 'isActiveCallback': 'NERDTreeSvnDirectoryCheck'})

function! NERDTreeSvnCommit()
    let curNode = g:NERDTreeFileNode.GetSelected()
    let chmodArg = input("commit message: ")
    execute '!svn commit ' . curNode.path.str({'escape': 1}) . ' -m "' . chmodArg . '" '
    if exists('g:loaded_signify') " signify force to refresh
       execute "SignifyRefresh"
    endif
    call curNode.refresh()
    call NERDTreeRender()
endfunction


call NERDTreeAddMenuItem({
            \ 'text': '(u)svn update',
            \ 'shortcut': 'u',
            \ 'callback': 'NERDTreeSvnUpdate',
            \ 'isActiveCallback': 'NERDTreeSvnDirectoryCheck'})

function! NERDTreeSvnUpdate()
    let curNode = g:NERDTreeFileNode.GetSelected() 
    execute '!svn update ' . curNode.path.str({'escape': 1}) 
    if exists('g:loaded_signify') " signify force to refresh
       execute "SignifyRefresh"
    endif
    call curNode.refresh()
    call NERDTreeRender()
endfunction



call NERDTreeAddMenuItem({
            \ 'text': '(z)svn sync',
            \ 'shortcut': 'z',
            \ 'callback': 'NERDTreeSvnSyncDirCallback',
            \ 'isActiveCallback': 'NERDTreeSvnDirectoryCheck'})

function! NERDTreeSvnSyncDirCallback()
    let curNode = g:NERDTreeFileNode.GetSelected()
    let chmodArg = input("commit message: ")
    " Deleted files
    execute "!svn status " . curNode.path.str({'escape': 1}) . "/ | grep '^\\!' | sed 's/\\! *//' | xargs -I\\% svn rm \\%"  
    " Add files
    execute '!svn add --force ' . curNode.path.str({'escape': 1}) . '  --auto-props --parents --depth infinity -q'
    " Commit files
    execute '!svn commit ' . curNode.path.str({'escape': 1}) . ' -m "' . chmodArg . '" '
    " Update files
    execute '!svn update ' . curNode.path.str({'escape': 1}) 
    if exists('g:loaded_signify') " signify force to refresh
       execute "SignifyRefresh"
    endif
    call curNode.refresh()
    call NERDTreeRender()
endfunction
