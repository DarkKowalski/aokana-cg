# frozen_string_literal: true

module AokanaCG
  class ImageInfo
    attr_reader :prefix, :index, :path, :type

    def initialize(path)
      @path = path
      @prefix = File.basename(path, '.webp').split('_').first
      @index = File.basename(path, '.webp').split('_').last[1..].to_i
      @type = File.basename(path, '.webp').split('_').last[0]
    end

    def base?
      @type == 'a'
    end

    def overlay?
      @type != 'a'
    end

    def to_s
      "Path: #{@path}, Prefix: #{@prefix}, Index: #{@index}, Type: #{@type}"
    end
  end
end
