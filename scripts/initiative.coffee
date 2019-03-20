# Description:
#   Initiaties a new member into the grapevine
#
# Commands:
#   hubot nomination start <user> - Starts a new nomination
#   hubot nomination vote yes/no - Votes for a nomination with yes/no
#   hubot nomination status - Display the current nomination status
#   hubot nomination abort - Aborts the current nomination
{WebClient} = require "@slack/client"

module.exports = (robot) ->
  web = new WebClient robot.adapter.options.token
  announcementChannel = "#general"

  web.channels.list()
    .then (res) ->
      room = res.channels.find (channel) -> channel.name is 'general'
      announcementChannel = room.id if room?
      robot.logger.info "Using #{announcementChannel} as announcement channel."
    .catch (error) -> robot.logger.error error.message

  robot.respond /nomination start (.*)/i, (res) ->
    if robot.brain.get('vote-in-progress') or false
      res.send "Nomination in progress."
    else
      web.users.list()
        .then (info) ->
          members = info.members.filter (x) -> !x.is_app_user && !x.deleted && !x.is_bot
          memberCount = members.length
          required = memberCount / 2 + 1
          robot.brain.set('member-count', memberCount)
          robot.brain.set('nominee', res.match[1].trim())
          robot.brain.set('vote-in-progress', true)
          res.send "Let's start the nomination process.\nJust open a private channel to me and send me\n`@tyler nomination vote yes` or `@tyler nomination vote no`\nWhen there are enough yes votes (#{required}), the nomination will end."
        .catch (error) -> robot.logger.error error.message

  robot.respond /nomination vote (yes|no)/, (res) ->
    if robot.brain.get('vote-in-progress') or false
      sender = robot.brain.usersForFuzzyName(res.message.user['name'])[0].name
      robot.logger.info "Counting vote for #{sender}.."
      votes = robot.brain.get('votes') or {}
      votes[sender] = if res.match[1] == "yes" then 1 else 0
      robot.brain.set('votes', votes)
      res.send "ok, counted or updated your vote."

      if checkVotes()
        nominee = robot.brain.get('nominee')
        robot.brain.set('votes', {})
        robot.brain.set('vote-in-progress', false)
        robot.messageRoom(announcementChannel, "Nomination ended. #{nominee} just got accepted.")
    else
      res.send "No nomination in progress."

  robot.respond /nomination status/i, (res) ->
    if robot.brain.get('vote-in-progress') or false
      count = getVotes()
      memberCount = robot.brain.get('member-count')
      nominee = robot.brain.get('nominee')
      required = memberCount / 2 + 1
      res.send "#{nominee} has #{count} votes of #{required}."
    else
      res.send "No nomination in progress."

  robot.respond /nomination abort/i, (res) ->
    if robot.brain.get('vote-in-progress') or false
      robot.brain.set('votes', {})
      robot.brain.set('vote-in-progress', false)
      res.send "Nomination aborted."
    else
      res.send "No nomination in progress."

  getVotes = () ->
    votes = robot.brain.get('votes') or {}
    count = 0

    for k,v of votes
      count += v

    count

  checkVotes = () ->
    count = getVotes()
    memberCount = robot.brain.get('member-count')

    if count > memberCount / 2
      true
    else
      false
