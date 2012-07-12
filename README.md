**vim-unite-svn + VCSCommands**

vim-unite-vcs
=====================

vim-unite-vcs defines unite sources and actions of any version control system (eg git, bazaar, mercurial, Subversion ). It can 

Installation
------------------------------


Example
------------------------------

### show log and diff revision

    :Unite vcs/log     " will be shown your commit logs.
                       " select a revision you want diff.
    <tab>              " press tab to choose an unite action
    diff               " choose diff action. will be shown diff between working copy and selected revision.
    
### check status and commit 

    :Unite vcs/status  " will be shown your commit logs.
                       " select file(s) you want to commit
    <tab>              " press tab to choose commit action
    commit             " choose commit action. 

Source
------------------------------
- vcs/log
- vcs/status
- (not yet)vcs/annotate 
- (not yet)vcs/branch


Actions
------------------------------

### vcs/log
- diff
 - Diff with revision(s) . If a revision was selected diff with working copy and two revisions were selected diff with each revisions.

### vcs/status
- commit
 - Commit file(s)
- add
 - Add file(s)
- delete
 - Delete file(s)
- revert 
 - Revert file(s)

