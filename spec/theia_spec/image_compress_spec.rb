# frozen_string_literal: true

require 'spec_helper'

describe Theia::ImageCompress do

  describe '.new' do
    subject(:new) { described_class.new('png') }
    it { expect(new.instance_variable_get('@type')).to eq 'png' }
	end

  describe '#to_png' do
    let(:theia) { described_class.new('png') }
    let(:options) {"compression_level": 9, "quality": 10, "adaptive_filtering": true}
    it 'compress images with size lower than original image' do
      input_file = '/spec/assets/png_image.png'
      output_file = '/spec/assets/compressed.png'
      val = theia.compress(input_file, output_file, options)
      expect(File.size(output_file)).to be < File.size(output_file)
    end
  end

  describe '#to_jpeg' do
    let(:theia) { described_class.new('jpg') }
    let(:options) {"compression_level": 9, "quality": 10, "adaptive_filtering": true}
    it 'compress images with size lower than original image' do
      input_file = '/spec/assets/png_image.jpg'
      output_file = '/spec/assets/compressed.jpg'
      val = theia.compress(input_file, output_file, options)
      expect(File.size(output_file)).to be < File.size(output_file)
    end
  end
end
