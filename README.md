# Stickynotes

## Targeted Capabilities (Stickynote) 

1. Open a buffer with most recent sticky note open
1. Create new sticky ready for edit
1. Let user scroll through notes that already exist
1. Telescope extension for listing notes - future capability

## History
- Started out wanting to be able to jot down notes while writing code.
    - Had an idea of opening a note file and writing in it, then dismissing until needed.
    - Thought about tying to 'projects' I was working on, or possibly having a global note.
- Had to really learn Lua.
- Found best practices and templates.
- Used some existing libraries for a bit (plenary, et. al.)
- Realized what I really needed was just a neovim implementation of the stickies app.

## TODO
- [ ] Add autocommands to save file when closing window
- [ ] Add autocommands to resize when vim window changes
- [ ] Add multiple file support  
- [ ] Fix the user command  
- [X] Rename to sticky notes  
- [X] Clean up some of the code  
- [X] Expose <plug> keymaps  
- [X] Update README  
- [X] Fix bug where window won't close if you open it twice.
