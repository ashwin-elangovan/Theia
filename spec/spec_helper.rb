# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'theia'
require 'mini_magick'
require 'byebug'

MiniMagick.validate_on_create = false