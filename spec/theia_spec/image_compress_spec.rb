# frozen_string_literal: true

require 'spec_helper'

describe Theia::ImageCompress do

  after(:all) do
    File.delete('compressed_png.png')
    File.delete('compressed_jpg.jpg')
  end

  describe '.new' do
    subject(:new) { described_class.new('png') }
    it { expect(new.instance_variable_get('@type')).to eq 'png' }
	end

  describe '#to_png' do
    let(:theia) { described_class.new('png') }
    let(:options) { { "compression_level" => 9, "quality" => 10, "adaptive_filtering" => true } }
    it 'compress images with size lower than original image' do
      input_file = "ex.png"
      output_file = "compressed_png.png"
      val = theia.compress(input_file, output_file, options)
      sleep 5
      expect(File.size(output_file)).to be < File.size(input_file)
    end
  end

  describe '#to_jpeg' do
    let(:theia) { described_class.new('jpg') }
    let(:options) { { "compression_level" => 9, "quality" => 10, "adaptive_filtering" => true } }
    it 'compress images with size lower than original image' do
      input_file = 'ex.jpg'
      output_file = 'compressed_jpg.jpg'
      val = theia.compress(input_file, output_file, options)
      sleep 5
      expect(File.size(output_file)).to be < File.size(input_file)
    end
  end
end
