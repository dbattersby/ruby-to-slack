class SlackMessage
  require 'json'

  def initialize message
    channel = ENV['SLACK_CHANNEL']
    username = ENV['SLACK_USERNAME']
    webhook_url = ENV['SLACK_WEBHOOK_URL']
    emoji = ENV['SLACK_EMOJI']

    # add caller file and line number for debugging purposes
    caller_details = caller.first.split(":")

    # make file path more readable
    if caller_details[0].split("/").size > 3
      caller_path = caller_details[0].split("/").last(3).join("/")
    else
      caller_path = caller_details[0]
    end

    # add new line onto message to show file path and line number
    message += "\n#{caller_path} on line #{caller_details[1]}"

    # set payload data
    data = { :channel => channel, :username => username, :text => message }
    data[:icon_emoji] = emoji unless emoji.blank?

    payload = data.to_json
    system("curl -X POST --data-urlencode 'payload=#{payload}' #{webhook_url}")
  end
end
