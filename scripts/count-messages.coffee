# Description:
#   Count observed messages
#
# Commands:
#   hubot Are you spying on us? - Returns the message counter spied upon
module.exports = (robot) ->

  robot.receiveMiddleware (context, next, done) ->
    messageCounter = robot.brain.get('messageCounter') or 0
    robot.brain.set 'messageCounter', messageCounter + 1
    next(done)

  robot.respond /are you spying on us/i, (res) ->
    messageCounter = robot.brain.get('messageCounter') or 0
    res.send "I spied upon #{messageCounter} messages until now."
