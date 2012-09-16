module NotCaptcha
  class CaptchaController < ::ApplicationController
    def show
      rotated_image = NotCaptcha::Cypher.decrypt params[:hash], params[:t]
      render file: '/tmp/rotated/#{rotated_image}.jpg', content_type: 'image/jpeg'
    end
  end
end