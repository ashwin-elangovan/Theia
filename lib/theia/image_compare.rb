require 'theia/exceptions'
require 'theia/utils'

module Theia
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
  					const image_diff = pixelmatch(image_1.data, image_2.data, diff.data, width, height, options);
  					fs.writeFileSync(output_file, PNG.sync.write(diff));
            return image_diff;
          }
        FUNCTION
      end
      method :compare_png, compare_image
    end

    def compare(image_1, image_2, output, options = {})
      return raise Exceptions::InvalidFileFormatError if Utils.invalid_file_format?('png', image_1, image_2)
      return_val = image_processor.compare_png(image_1, image_2, output, construct_params(options))
      return_val
    end

    private

    def construct_params options
      return if options.empty?
      permitted_options = options.slice(:alpha, :aa_color, :include_a_a, :threshold, :diff_color, :diff_mask)
      Utils.normalize_object permitted_options
    end

    def image_processor
      Theia::ImageCompare::Processor.new(Utils.root_path)
    end
  end
end
