domain=Domain.create name: "lvh.me", x:0, y:0
Host.create name: "lvh.me", parent: domain, x:0, y:0
domain=Domain.create name: "quest.interactiff.net", x:0, y:0
Host.create name: "quest.interactiff.net", parent: domain, x:0, y:0


# game=Game.create name: "Test game", parent: domain, x:100, y:100
# task=Task.create name: "Test task", parent:game, game:game, x:100, y:100
#
# tg=TaskGiven.create x:0, y:0, parent:task, task:task, game:game
# hint=Hint.create x:100, y:100, parent:task, task:task, game:game
# Relation.create from:tg, to:hint, game:game
#
# answer=Answer.create x:200, y:200, parent:task, task:task, game:game
# tp=TaskPassed.create x:400, y:400, parent:task, task:task, game:game
# Relation.create from:answer, to:tp, game:game