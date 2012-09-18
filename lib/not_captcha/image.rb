require "mini_magick"

module NotCaptcha
  class Image
    BACKGROUND = 'white'
    COMPOSITE_GRAVITY = 'West'

    attr_accessor :name, :width
    
    def initialize image, answer, output
      @answer = answer
      @image = image
      @name = output

      image_cloned = original_image
      @width = image_cloned[:width]
      @height = image_cloned[:height]
      @rotate_offset = (((@height**2.0+@width**2.0)**(1.0/2)-(@width+@height)/2)/2).to_i

      unless File.exists? composite_path(@name)
        0.upto(7) do |i|
          next if i == @answer
          deg = i < @answer ? "-#{(@answer-i)*45}" : "+#{(i-@answer)*45}"
          image_cloned.combine_options do |c|
            c.rotate deg
            c.crop "#{@width}x#{@height}+#{@rotate_offset*((i-answer)%2)}+#{@rotate_offset*((i-answer)%2)}"
          end
          self.wide_image = wide_image.composite(image_cloned) do |c|
            c.gravity COMPOSITE_GRAVITY
            c.geometry "+#{@width*i}+0"
          end
          image_cloned = original_image
        end

        wide_image.write composite_path @name
      end
    end

    def original_image
      MiniMagick::Image.open(@image)
    end

    def wide_image
      unless @wide_image
        @wide_image = original_image
        @wide_image.combine_options do |mogrify|
          mogrify.fill BACKGROUND
        end

        @wide_image.combine_options(:convert) do |convert|
          convert.size "#{@width*8}x#{@height}"
          convert.xc BACKGROUND
          convert.swap '0,1'
          convert.gravity COMPOSITE_GRAVITY
          convert.geometry "+#{@width*@answer}+0"
          convert.composite
        end
      end
      @wide_image
    end

    def wide_image= image
      @wide_image = image
    end

    def composite_path name
      NotCaptcha::Image.composite_path name
    end


    def self.get_random_image_path
      NotCaptcha::Image.images[Random.rand(0...NotCaptcha::Image.images.size)]
    end

    def self.get_composite_image image, answer
      original_name = File.basename(image, File.extname(image))

      composite_name = "#{original_name}_#{answer}"
      NotCaptcha::Image.new image, answer, composite_name
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