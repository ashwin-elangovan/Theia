# frozen_string_literal: true

require 'spec_helper'

describe Theia::Screenshot do
  let(:theia) { described_class.new(website_url) }
  let(:website_url) { 'http://example.com' }
  let(:device) { 'Kindle Fire HDX' }
  let(:options) { {} }

  describe '.new' do
    subject(:new) { described_class.new('http://example.com') }
    it { expect(new.instance_variable_get('@url')).to eq 'http://example.com' }
	end

  describe '#to_png' do
    subject(:to_png) { theia.to_png("ex.png") }
    let(:image) { MiniMagick::Image.read to_png }

    it { expect(to_png.unpack('C*')).to start_with "\x89PNG\r\n\x1A\n".unpack('C*') }
    it { expect(image.type).to eq 'PNG' }
    it { expect(image.dimensions).to eq [1600, 2560] }
  end

  describe '#to_jpeg' do
    subject(:to_jpeg) { theia.to_jpeg("ex.jpg") }

    let(:image) { MiniMagick::Image.read to_jpeg }

    it { expect(to_jpeg.unpack('C*')).to start_with [0xFF, 0xD8, 0xFF] }
    it { expect(to_jpeg[6..9]).to eq 'JFIF' }
    it { expect(to_jpeg.unpack('C*')).to end_with [0xFF, 0xD9] }
    it { expect(image.type).to eq 'JPEG' }
    it { expect(image.dimensions).to eq [1600, 2560] }
  end
end