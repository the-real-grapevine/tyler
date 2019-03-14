# Description:
#   Modify the grapevine rules
#
# Commands:
#   hubot grapevine rules - Lists the grapevine rules
#   hubot intialize grapevine rules - Initializes the grapevine rules
#   hubot add grapevine rule <rule> - Adds a rule to the grapevine rules
module.exports = (robot) ->

  robot.respond /grapevine rules/i, (res) ->
    rules = robot.brain.get('grapevine-rules') or []
    res.send rules.join('\n')

  robot.respond /initialize grapevine rules/i, (res) ->
    rules = []
    rules.push("*#{rules.length + 1}*: You do not talk about THE REAL GRAPEVINE.")
    rules.push("*#{rules.length + 1}*: You DO NOT talk about THE REAL GRAPEVINE.")
    rules.push("*#{rules.length + 1}*: What happens inside THE REAL GRAPEVINE, stays inside THE REAL GRAPEVINE.")
    rules.push("*#{rules.length + 1}*: Rumors will go on as long as they have to.")
    rules.push("*#{rules.length + 1}*: If this is your first day at THE REAL GRAPEVINE, you have to learn the rules.")
    rules.push("*#{rules.length + 1}*: Thou shalt not have no other grapevine slacks before me.")
    robot.brain.set('grapevine-rules', rules)
    res.send "ok, initialized grapevine rules."

  robot.respond /add grapevine rule (.*)/i, (res) ->
    rules = robot.brain.get('grapevine-rules') or []
    rule = res.match[1].trim()
    rules.push("*#{rules.length + 1}*: " + rule)
    robot.brain.set('grapevine-rules', rules)
    res.send "ok, added #{rule} to the grapevine rules."
