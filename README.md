# Theia

A Ruby gem to 

1) Transform website URL into PNGs or JPEGs using [Google Puppeteer](https://github.com/GoogleChrome/puppeteer).
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

### Screenshot

```ruby
# Theia accepts a valid website URL for initialization.
theia = Theia::Screenshot.new(<website_url>)

# Get a screenshot

png = theia.to_png(<save_location>, options)
jpeg = theia.to_jpeg(<save_location>, options) 
```
#### Options
* `full_page` When true, takes a screenshot of the full scrollable page. Defaults to false, values: `true/false`
* `device` Devices which will be used to generate screenshot, values: `mobile, iphone, ipad, desktop and their respective landscapes by appending _landscape`
* `url` Valid website URL, eg: `https://www.google.com`
* `quality` The quality of the image, between 0-100. Not applicable to png images, values: 0-100
* `omit_background` Hides default white background and allows capturing screenshots with transparency. Defaults to false.





