# ruby-to-slack
Send debug information to Slack channel directly from Ruby. This was designed to be used in Ruby on Rails 6 applications. However, you could use this in a non Rails environment too.

## Setup Details for Ruby on Rails
Copy the slack_message.rb file into /lib/ directory within your Rails app.

Follow steps 1-3 in this guide to create your slack app, turn on incoming webhook messages and create webhook address:
https://api.slack.com/messaging/webhooks

Note: The slack channel should be set as public.

Create the environment variables. It is best practice to keep sensitive information outside of version controlled code. Make sure to change the channel name and webhook url, username and emoji can be changed to suit your preference.

```
SLACK_CHANNEL: '#bug-tracking'
SLACK_WEBHOOK_URL: 'YOUR_SLACK_WEBHOOK_URL'
SLACK_USERNAME: 'alerts-bot'
SLACK_EMOJI: 'technologist'
```

Require the slack_message file from wherever you are trigger the slack notification. In this example, I'll add it to the User model:
```
class User < ActiveRecord::Base
  require "slack_message"
end
```

Then within the model, you can trigger the slack message where needed:

```
def process_payment(amount = nil)
  begin
    some code here...
  rescue => e
    SlackMessage.new "Stripe Charge error:\nStripe customer id: #{stripe.stripe_id}, User ID: #{self.id}, Amount: #{ amount }"
  end
end
```

## Non Rails Setup
For Ruby only projects, you will need to populate the ENV variables.

Once the ENV vars are set, you can require the slack_message.rb file directly from your Ruby file.
```
require "slack_message"
```

Then call the slack message when you want to send a notification to Slack:
```
SlackMessage.new "Job failed, see details:\n#{self} with #{args.inspect}"
```
