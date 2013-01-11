require 'not_captcha/image'
require 'not_captcha/html'
require 'not_captcha/cypher'

module NotCaptcha
  class Engine < Rails::Engine
  end
  
  def self.generate
    time = Time.now.to_i
    width = 0

    hashs = [1,2,3].map do |i|
      answer = Random.rand(0..7) # deg: 0, 45, 90, 135, 180, 225, 270, 315
      original_path = NotCaptcha::Image.get_random_image_path
      composite_image = NotCaptcha::Image.get_composite_image original_path, answer
      width = composite_image.width
      composite_image.hash(time)
    end

    #TODO: do it right
    NotCaptcha::HTML.generate_captcha hashs, time, width
  end
  
  def self.check params, ip
    composite_name = NotCaptcha::Cypher.decrypt params[:hashes]['0'], params[:time]
    return false unless NotCaptcha::Image.answer_for(composite_name)==params[:imgoneField]
    composite_name = NotCaptcha::Cypher.decrypt params[:hashes]['1'], params[:time]
    return false unless NotCaptcha::Image.answer_for(composite_name)==params[:imgtwoField]
    composite_name = NotCaptcha::Cypher.decrypt params[:hashes]['2'], params[:time]
    return false unless NotCaptcha::Image.answer_for(composite_name)==params[:imgthreeField]
    true
  rescue
    false
  end  
end
