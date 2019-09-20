require 'theia/exceptions'
require 'theia/utils'

class Theia
  class ImageCompare
    #
    # Processor helper class for calling out to Pixelmatch NodeJS library
    #
    class Processor < Schmooze::Base
    	dependencies pixelmatch: 'pixelmatch'

    	def self.compare_image
        <<~FUNCTION
          async (old_image, new_image, output_file, options) => {
          	const fs = require('fs');
  					const PNG = require('pngjs').PNG;
  					const pixelmatch = require('pixelmatch');
  					const image_1 = PNG.sync.read(fs.readFileSync(old_image));
  					const image_1 = PNG.sync.read(fs.readFileSync(new_image));
  					const { width, height } = image_1;
  					const diff = new PNG({ width, height });
  					pixelmatch(image_1.data, image_2.data, diff.data, width, height, options);
  					fs.writeFileSync(output_file, PNG.sync.write(diff));
          }
        FUNCTION
      end
      method :compare_png, compare_image
    end

    def compare(image_1, image_2, output, options = nil)
      return raise Exceptions::InvalidFileFormatError if Utils.invalid_file_format?('png', image_1, image_2)
      image_processor.compare_png(image_1, image_2, output, construct_params(options))
    end

    private

    def compare_params options
      return if options.nil?
      permitted_options = options.permit(:alpha, :aa_color, :include_a_a, :threshold, :diff_color)
      Utils.normalize_object permitted_options
    end

    def image_processor
      Theia::ImageCompare::Processor.new(Utils.root_path)
    end
  end
end
