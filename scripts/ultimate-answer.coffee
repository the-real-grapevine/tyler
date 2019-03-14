# Description:
#   Answers to the ultimate question
#
# Commands:
#   hubot What is the answer to the ultimate question of life? - Returns the answer
module.exports = (robot) ->

  answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING

  robot.respond /what is the answer to the ultimate question of life/i, (res) ->
    unless answer?
      res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
      return
    res.send "#{answer}, but what is the question?"
