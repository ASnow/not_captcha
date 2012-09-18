require 'not_captcha/image'
require 'not_captcha/html'
require 'not_captcha/cypher'

module NotCaptcha
  
  def self.generate
    time = Time.now.to_i
    answer = Random.rand(0..7) # deg: 0, 45, 90, 135, 180, 225, 270, 315
    original_path = NotCaptcha::Image.get_random_image_path
    composite_image = NotCaptcha::Image.get_composite_image original_path, answer

    hash = NotCaptcha::Cypher.encrypt composite_image.name, time

    #TODO: do it right
    NotCaptcha::HTML.generate_captcha [hash,hash,hash], time, composite_image.width
  end
  
  def self.check params
    composite_name = NotCaptcha::Cypher.decrypt params[:hash], params[:time]
    NotCaptcha::Image.answer_for(composite_name)==params[:answer]
  end  
end