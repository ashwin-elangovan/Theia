# frozen_string_literal: true

require 'spec_helper'

describe Theia::Utils do
  describe '.deep_transform_keys_in_object' do
    subject(:deep_transform_keys_in_object) do
      described_class.deep_transform_keys_in_object(hash) { |key| key.to_s.upcase }
    end

    context 'when hash is empty' do
      let(:hash) { {} }

      it { is_expected.to eq({}) }
    end

    context 'when hash has basic keys' do
      let(:hash) { { foo: 'bar' } }

      it { is_expected.to eq('FOO' => 'bar') }

      it 'doesnt modify the original hash' do
        deep_transform_keys_in_object
        expect(hash).to eq(foo: 'bar')
      end
    end

    context 'when hash contains an array of hashes' do
      let(:hash) { { foo: [{ bar: 'baz' }] } }

      it { is_expected.to eq('FOO' => [{ 'BAR' => 'baz' }]) }

      it 'doesnt modify the original hash' do
        deep_transform_keys_in_object
        expect(hash).to eq(foo: [{ bar: 'baz' }])
      end
    end
  end

  describe '.deep_stringify_keys' do
    subject(:deep_stringify_keys) { described_class.deep_stringify_keys(hash) }

    context 'when hash is empty' do
      let(:hash) { {} }

      it { is_expected.to eq({}) }
    end

    context 'when hash has keys' do
      let(:hash) { { foo: 'bar' } }

      it { is_expected.to eq('foo' => 'bar') }

      it 'doesnt modify the original hash' do
        deep_stringify_keys
        expect(hash).to eq(foo: 'bar')
      end
    end
  end

  describe '.normalize_object' do
    subject(:normalize_object) { described_class.normalize_object(object) }

    context 'when key is a single-word symbol' do
      let(:object) { { foo: 'bar' } }

      it { is_expected.to eq('foo' => 'bar') }
    end

    context 'when key is a multi-word symbol' do
      let(:object) { { foo_bar: 'baz' } }

      it { is_expected.to eq('fooBar' => 'baz') }
    end

    context 'when key is a single-word string' do
      let(:object) { { 'foo' => 'bar' } }

      it { is_expected.to eq('foo' => 'bar') }
    end

    context 'when key is a multi-word string' do
      let(:object) { { 'foo_bar' => 'baz' } }

      it { is_expected.to eq('fooBar' => 'baz') }
    end

    context 'when key is up-case' do
      let(:object) { { 'FOO_BAR' => 'baz' } }

      it { is_expected.to eq('fooBar' => 'baz') }
    end

    context 'when key has an acronym in it' do
      let(:object) { { prefer_css_page_size: true } }

      it { is_expected.to eq('preferCssPageSize' => true) }
    end

    context 'with nested Hashes' do
      let(:object) { { margin: { top: '5px' } } }

      it { is_expected.to eq('margin' => { 'top' => '5px' }) }
    end

    context 'when value is a number' do
      let(:object) { { scale: 1.34 } }

      it { is_expected.to eq('scale' => 1.34) }
    end
  end
end