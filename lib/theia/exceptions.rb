class Theia
  class Exceptions
    class InvalidFileFormatError < StandardError
      def initialize
        super('Invalid File Format')
      end
    end
  end
end
