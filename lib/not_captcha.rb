module NotCaptcha
  
  def self.generate
    time = Time.now.to_i
    answer = Random.rand(0..7) # deg: 0, 45, 90, 135, 180, 225, 270, 315
    original_path = NotCaptcha::Image.get_random_image_path
    composite_name = NotCaptcha::Image.get_composite_name original_path, answer

    hash = NotCaptcha::Cypher.encrypt composite_name, time

    NotCaptcha::HTML.generate_captcha hash, time
  end
  
  def self.check params
    composite_name = NotCaptcha::Cypher.decrypt params[:hash], params[:time]
    NotCaptcha::Image.answer_for(composite_name)==params[:answer]
  end  
end