
if exists("g:loaded_nerdtree_svn_menuitem")
    finish
endif
let g:loaded_nerdtree_svn_menuitem = 1
let g:svn_message = ''

function! NERDTreeSvnDirectoryCheck()
    let curNode = g:NERDTreeFileNode.GetSelected()
    if curNode.path.isDirectory
        let output = system("svn info ".curNode.path.str() . g:NERDTreePath.Slash())
        if output !~ "E155007"
            return 1
        endif
    endif
    return 0
endfunction


call NERDTreeAddMenuItem({
            \ 'text': '(w)svn commit',
            \ 'shortcut': 'w',
            \ 'callback': 'NERDTreeSvnCommit',
            \ 'isActiveCallback': 'NERDTreeSvnDirectoryCheck'})

function! NERDTreeSvnCommit()
    let curNode = g:NERDTreeFileNode.GetSelected()
    let g:svn_message = input('Commit Message: ', g:svn_message)
    redraw
    execute '!svn commit ' . curNode.path.str({'escape': 1}) . ' -m "' . g:svn_message . '" '
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
    redraw
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
    let g:svn_message = input('Commit Message: ', g:svn_message)
    " Deleted files
    execute "!svn status " . curNode.path.str({'escape': 1}) . "/ | grep '^\\!' | sed 's/\\! *//' | xargs -I\\% svn rm \\%"  
    " Add files
    execute '!svn add --force ' . curNode.path.str({'escape': 1}) . '  --auto-props --parents --depth infinity -q'
    " Commit files
    execute '!svn commit ' . curNode.path.str({'escape': 1}) . ' -m "' . g:svn_message . '" '
    " Update files
    execute '!svn update ' . curNode.path.str({'escape': 1}) 
    if exists('g:loaded_signify') " signify force to refresh
       execute "SignifyRefresh"
    endif
    call curNode.refresh()
    call NERDTreeRender()
endfunction
