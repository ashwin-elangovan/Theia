# frozen_string_literal: true

class Theia
  #
  # Utility class for Theia helper methods
  #
  class Utils
    def self.root_path
      @root_path ||= Dir.pwd
    end

    #
    # Deep transform the keys in an object (Hash/Array)
    #
    # Duplicated from active support
    # @see active_support/core_ext/hash/keys.rb
    #
    def self.deep_transform_keys_in_object(object, &block)
      case object
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[yield(key)] = deep_transform_keys_in_object(value, &block)
        end
      when Array
        object.map { |e| deep_transform_keys_in_object(e, &block) }
      else
        object
      end
    end

    #
    # Deep transform the keys in the hash to strings
    #
    def self.deep_stringify_keys(hash)
      deep_transform_keys_in_object hash, &:to_s
    end

    #
    # Recursively normalizes hash objects with camelized string keys
    #
    def self.normalize_object(object)
      deep_transform_keys_in_object(object) { |k| normalize_key(k) }
    end

    #
    # Normalizes hash keys into camelized strings, including up-casing known acronyms
    #
    # Regex sourced from ActiveSupport camelize
    #
    def self.normalize_key(key)
      key.to_s.downcase.gsub(%r{(?:_|(/))([a-z\d]*)}) do
        "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
      end
    end
    private_class_method :normalize_key

    # Precondition methods

    def self.compress_preconditions(type, input_file, output_file)
      unsupported_compression?(type) || invalid_file_format?(type, input_file, output_file)
    end

    def self.unsupported_compression?(type)
      type != ('png' || 'jpg')
    end

    def self.invalid_file_format?(type, input, output)
      input_format = input.split('.').last
      output_format = output.split('.').last
      type != (input_format || output_format)
    end
  end
end
