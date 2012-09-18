module NotCaptcha
  class CaptchaController < ActionController::Base
    skip_filter(*_process_action_callbacks.map(&:filter), :only => :show)
    def show
      rotated_image = NotCaptcha::Cypher.decrypt params[:hash], params[:t]
      send_file NotCaptcha::Image.composite_path(rotated_image), type: 'image/jpeg', disposition: 'inline'
    end
  end
end