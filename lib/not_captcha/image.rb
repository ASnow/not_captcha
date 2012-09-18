module NotCaptcha
  class Image
    def self.get_random_image_path
      NotCaptcha::Image.images[Random.rand(0...NotCaptcha::Image.images.size)]
    end

    def self.get_composite_name image, answer
      original_name = File.basename(image, File.extname(image))
      original_image = MiniMagick::Image.open(image)
      width = original_image[:width] 

      composite_name = "#{original_name}_#{answer}"
      unless File.exists? composite_path(composite_name)
        composite_image = MiniMagick::Image.open(composite_path(composite_name))
        
        0.upto(7) do |i|
          deg = i < answer ? 360-(answer-i)*45 : (i-answer)*45
          rotated_image = original_image.rotate(deg)
          composite_image = composite_image.composite(i*width, 0, 0, 0, rotated_image)
        end
        composite_image.write composite_path composite_name
      end

      composite_name
    end

    def self.answer_for image_name
      image.split('_')[-1]
    end

    def self.composite_path image_name
      "#{Rails.root}/lib/not_captcha/rotated/#{image_name}.jpg"
    end

    protected

    def self.images
      @images ||= Dir["#{Rails.root}/lib/not_captcha/images/*.jpg"]
    end
  end
end