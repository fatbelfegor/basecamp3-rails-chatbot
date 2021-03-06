class Api::Gitlab::MessagesController < ApplicationController
  def create
    # Get the parsed JSON string
    gitlab_parsed = Chatbot.parse_webhook(request.body.read)

    # error: JSON:ParserError
    # Get the failed JSON request message
    request_error = gitlab_parsed[:error]

    # Prepare message for the campfire
    message = if request_error
                "Failed or non-JSON request:#{request_error}"
              else
                build_message_text gitlab_parsed
              end

    # send message to basecamp
    Chatbot.send_message(command_params[:callback_url], message)
  end

  private

  def build_message_text(gitlab_parsed)
    # Store parsed dada from GitLab
    project_name = gitlab_parsed['project']['name']
    event = gitlab_parsed['object_kind']
    project_url = gitlab_parsed['project']['web_url']
    return "<strong>Gitlab project:</strong>  #{project_name}<br/>
           <strong>Event:</strong>  #{event}<br/>
           <strong>Project url:</strong>  #{project_url}"
  rescue NoMethodError => e # del. exception handlidg to see errors in console
    return "<strong>GitLab parsing error:</strong>  #{e}"
  end
end
