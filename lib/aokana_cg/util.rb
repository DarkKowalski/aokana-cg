# frozen_string_literal: true

require 'mini_magick'
require 'fileutils'

module AokanaCG
  module Util
    def self.merge(base, overlay_list)
      # return unless base.base? && overlay_list.all?(&:overlay?)

      base_image = MiniMagick::Image.open(base.path)
      overlay_image_list = overlay_list.map { |overlay| MiniMagick::Image.open(overlay.path) }

      merge_overlay_list(base_image, overlay_image_list)
    end

    def self.merge_overlay_list(base, overlay_list)
      merged = base
      overlay_list.each do |overlay|
        merged = merge_overlay(merged, overlay)
      end

      merged
    end

    def self.merge_overlay(base, overlay)
      base.composite(overlay) do |m|
        m.compose 'Over'
        m.geometry '+0+0'
      end
    end

    def self.save_image(image, path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, 'wb') { |f| f.write(image.to_blob) }
    end

    def self.auto_merge_and_save(input_files, output_file)
      raise 'Input files should be 2 or more' if input_files.size < 2

      image_info_list = input_files.map { |path| ImageInfo.new(path) }
      base_image_info_list = image_info_list.select(&:base?)
      raise "Base image should be 1 but not #{base_image_info_list.size}" if base_image_info_list.size > 1

      overlay_image_info_list = image_info_list.select(&:overlay?)
      merged_image = merge(base_image_info_list.first, overlay_image_info_list)
      save_image(merged_image, output_file)
    end
  end
end
