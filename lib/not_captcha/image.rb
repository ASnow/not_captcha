require "mini_magick"

module NotCaptcha
  class Image
    BACKGROUND = 'white'
    COMPOSITE_GRAVITY = 'West'
    
    def self.get_random_image_path
      NotCaptcha::Image.images[Random.rand(0...NotCaptcha::Image.images.size)]
    end

    def self.get_composite_name image, answer
      original_name = File.basename(image, File.extname(image))
      original_image = MiniMagick::Image.open(image)
      width = original_image[:width]
      height = original_image[:height]

      composite_name = "#{original_name}_#{answer}"
      unless File.exists? composite_path(composite_name)

      end
####
      image_cloned = MiniMagick::Image.open(image)

      image_cloned.combine_options do |mogrify|
        mogrify.fill BACKGROUND
        mogrify.rotate "+45"
        mogrify.gravity "center"
      end

      image_cloned.combine_options(:convert) do |convert|
        new_width = original_image[:width]*8
        hypo = (height**2.0+width**2.0)**(1.0/2)
        convert.size "#{new_width}x#{height}"
        convert.xc BACKGROUND
        convert.swap '0,1'
        convert.gravity COMPOSITE_GRAVITY
        convert.geometry "+#{width-(hypo-(width+height)/2)/2}+0"
        convert.composite
      end

      composite_image = image_cloned.composite(original_image) do |c|
        c.gravity COMPOSITE_GRAVITY
        c.geometry "+0+0"
      end
      composite_image.write composite_path composite_name

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