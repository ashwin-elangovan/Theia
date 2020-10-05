# Theia

A Ruby gem to 

1) Transform website URL into PNGs or JPEGs using [Puppeteer](https://github.com/GoogleChrome/puppeteer).
2) Compare two images using Node JS Library [Pixelmatch](https://github.com/mapbox/pixelmatch)
3) Compress an image using Sharp [Sharp](https://github.com/lovell/sharp)

## Installation

### Ruby Dependencies

Add this line to your application's Gemfile:

```ruby
gem 'theia'
```

### Node dependencies

```bash
nvm use 10.16.3
npm install puppeteer pixelmatch sharp
```

## Usage

### Screenshot [Google Puppeteer]

```ruby
# Theia screenshot accepts a valid website URL for initialization.
theia_screenshot = Theia::Screenshot.new(<website_url>)

# Get a screenshot
png = theia_screenshot.to_png(<save_location>, options)
jpeg = theia_screenshot.to_jpeg(<save_location>, options) 
```
`<save_location>` must be in the format of `output_file.png` or `output_file.jpg`

#### Options

`options` is an object literal with the following properties:

* `full_page` When true, takes a screenshot of the full scrollable page. Defaults to false, values: `true/false`
* `device` Devices which will be used to generate screenshot, values: `mobile, iphone, ipad, desktop` and their respective landscapes by appending `_landscape`
* `url` Valid website URL, eg: `https://www.google.com`
* `quality` The quality of the image, between `0-100`. Not applicable to png images, values: 0-100
* `omit_background` Hides default white background and allows capturing screenshots with transparency. Defaults to false, values: `true/false`

### Image Compare [Pixelmatch]

```ruby
theia_compare = Theia::ImageCompare.new

# Compare 2 pngs
theia_compare.compare(<file1.png>, <file2.png>, <output.png>, options)
```

Only PNG compare is supported now. JPEG will be added in the near future.

#### Options

`options` is an object literal with the following properties:

* `threshold` Matching threshold, ranges from `0` to `1`. Smaller values make the comparison more sensitive. `0.1` by default.
* `include_a_a` If `true`, disables detecting and ignoring anti-aliased pixels. `false` by default.
* `alpha` Blending factor of unchanged pixels in the diff output. Ranges from `0` for pure white to `1` for original brightness. `0.1` by default.
* `aa_color` The color of anti-aliased pixels in the diff output in `[R, G, B]` format. `[255, 255, 0]` by default.
* `diff_color` The color of differing pixels in the diff output in `[R, G, B]` format. `[255, 0, 0]` by default.
* `diff_mask` Draw the diff over a transparent background (a mask), rather than over the original image. Will not draw anti-aliased pixels (if detected).

Compares two images, writes the output diff and returns the number of mismatched pixels.

### Image Compress [Sharp]

```ruby
theia_compress = Theia::ImageCompress.new(<image_type>)

# Compress an image
theia_compare.compress(<file1>, <output>, options)
```
Currently `png` and `jpeg` images are supported.

`options` is an object literal with the following properties:

* `compression_level` zlib compression level, 0-9 (optional, default 9). Only for PNGs
* `quality` Use the lowest number of colours needed to achieve given quality, requires libvips compiled with support for libimagequant (optional, default 100)
* `force` Boolean force JPEG/PNG output, otherwise attempt to use input format (optional, default true)
* `adaptive_filtering` Use adaptive row filtering (optional, default false)
* `palette` Quantise to a palette-based image with alpha transparency (boolean)
* `colours` Maximum number of palette entries, requires libvips compiled with support for libimagequant (optional, default 256)
* `progressive` Only for JPEG. Use progressive (interlace) scan (optional, default false)
* `optimise_coding` Only for JPEG. Optimise Huffman coding tables (optional, default true)




