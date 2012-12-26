Mousetrap.bind ['backspace','del'], -> fieldView.deleteKey()
Mousetrap.bind 'up', -> Joygen.Views.Admin.BlockView.prototype.move(0,-gridStep)
Mousetrap.bind 'down', -> Joygen.Views.Admin.BlockView.prototype.move(0,gridStep)
Mousetrap.bind 'left', -> Joygen.Views.Admin.BlockView.prototype.move(-gridStep,0)
Mousetrap.bind 'right', -> Joygen.Views.Admin.BlockView.prototype.move(gridStep,0)
# Mousetrap.bind ['q','й','Q','Й'], -> floatingToolbarView.show() if editBlock!=parentBlock
#Mousetrap.bind ['1','2','3','4','5'], -> alert('')
#ctrl+s