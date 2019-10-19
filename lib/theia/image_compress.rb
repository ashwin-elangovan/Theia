require 'theia/exceptions'
require 'theia/utils'

class Theia
  class ImageCompress
    #
    # Processor helper class for calling out to Sharp NodeJS library
    #
    class Processor < Schmooze::Base
      dependencies sharp: 'sharp'

      def self.compress_png
        <<-FUNCTION
	      async (input_file, output_file, options) => {
						const input = sharp(input_file);
						const new_png = input.png(options);
						new_png.toFile(output_file, function(err, info) {
              console.log("Error while compressing png image")
            });
	        }
        FUNCTION
      end

      def self.compress_jpg
        <<-FUNCTION
        async (input_file, output_file, options) => {
            const input = sharp(input_file);
            const new_jpg = input.jpg(options);
            new_jpg.toFile(output_file, function(err, info) {
              console.log("Error while compressing jpeg image")
            });
          }
        FUNCTION
      end

      method :png, compress_png
      method :jpg, compress_jpg
    end

    def initialize(type)
      @type = type
    end

    def compress(input_file, output_file, options = {})
      return raise Exceptions::InvalidFileFormatError if Utils.compress_preconditions(@type, input_file, output_file)
      image_processor.send(@type.to_sym, input_file, output_file, construct_params(options))
    end

    def construct_params options
      return if options.empty?
      permitted_options = options.slice(:compression_level, :quality, :adaptive_filtering, :palette, :colours, :progressive, :optimise_coding, :force)
      Utils.normalize_object permitted_options
    end

    private

    def image_processor
      Theia::ImageCompress::Processor.new(Utils.root_path)
    end
  end
end
