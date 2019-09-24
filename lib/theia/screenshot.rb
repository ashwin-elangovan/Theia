require 'theia/utils'
require 'schmooze'
require 'theia/exceptions'

class Theia
  class Screenshot

    DEFAULT_DEVICE = 'Kindle Fire HDX'.freeze

    DEVICES = [
      [:mobile, 'Pixel 2 XL'],
      [:mobile_landscape, 'Pixel 2 XL landscape'],
      [:iphone, 'iPhone XR'],
      [:iphone_landscape, 'iPhone XR landscape'],
      [:ipad, 'iPad Pro'],
      [:ipad_landscape, 'iPad Pro landscape'],
      [:desktop, 'Kindle Fire HDX'],
      [:desktop_landscape, 'Kindle Fire HDX landscape']
    ]

    DEVICE_HASH = Hash[*DEVICES.map { |i| [i[0], i[1]] }.flatten]
      #
      # Processor helper class for calling out to Puppeteer NodeJS library
      #
    class Processor < Schmooze::Base
      dependencies puppeteer: 'puppeteer'

      def self.convert_function
        <<~FUNCTION
          async (website_url, device, options) => {
            let browser;
            try {
              // Launch the browser and create a page
              browser = await puppeteer.launch();
              const page = await browser.newPage();
              const devices = require('puppeteer/DeviceDescriptors');
              await page.emulate(devices[device]);
              await page.goto(website_url);
              await page.screenshot(options);
            } finally {
              if (browser) {
                await browser.close();
              }
            }
          }
        FUNCTION
      end
      method :convert_screenshot, convert_function
    end

    def initialize(url)
      @url = url
    end

    #
    # Request URL with provided options and create screenshot
    #
    def screenshot(path, format, options)
      device = DEVICE_HASH[options[:device]&.to_sym] || DEFAULT_DEVICE
      custom_params = construct_params(path, format, options.except!(:device))
      result = processor.convert_screenshot @url, device, custom_params
      return unless result
      result['data'].pack('C*')
    end

    def construct_params(path, format, options)
      path ||= DEFAULT_PATH
      params = { path: path }
      allowed_options = options.slice(:quality, :clip, :omit_background, :full_page)
      normalized_options = Utils.normalize_object allowed_options
      params.merge!(normalized_options)
      params['type'] = format if format.is_a? ::String
      params
    end

    #
    # Request URL with provided options and create PNG
    #
    def to_png(path, options = {})
      return raise Exceptions::InvalidFileFormatError unless valid_output_format?(path, 'png')
      screenshot(path, 'png', options)
    end

    #
    # Request URL with provided options and create JPEG
    #
    def to_jpeg(path, options = {})
      return raise Exceptions::InvalidFileFormatError unless valid_output_format?(path, 'jpeg')
      screenshot(path, 'jpeg', options)
    end

    private

    def processor
      Theia::Screenshot::Processor.new(Utils.root_path)
    end

    def valid_output_format?(path, format)
      given_format = path.split('.').last
      format == given_format
    end
  end
end