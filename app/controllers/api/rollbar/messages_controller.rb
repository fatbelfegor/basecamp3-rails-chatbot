class Api::Rollbar::MessagesController < ApplicationController
  def create
    # Get the parsed JSON string
    rollbar_parsed = Chatbot.parse_webhook(request.body.read)

    # error: JSON:ParserError
    # Get the failed JSON request message
    request_error = rollbar_parsed[:error]

    # Prepare message for the campfire
    message = if request_error
                "Failed or non-JSON request: #{request_error}"
              else
                build_message_text rollbar_parsed
              end

    # send message to basecamp
    Chatbot.send_message(command_params[:callback_url], message)
  end

  private

  def build_message_text(rollbar_parsed)
    # Store parsed dada from Rollbar
    event = rollbar_parsed['event_name']
    data = rollbar_parsed['data']['item']['title']
    uuid = rollbar_parsed['data']['occurrence']['uuid']
    event_url = "https://rollbar.com/instance/uuid?uuid=#{uuid}"
    return "<strong>Event:</strong>  #{event}<br/>
           <strong>Body:</strong>  #{data}<br/>
           <strong>Rollbar report:</strong>  #{event_url}"
  rescue NoMethodError => e # del. exception handlidg to see errors in console
    return "<strong>Rollbar parsing error:</strong>  #{e}"
  end
end
