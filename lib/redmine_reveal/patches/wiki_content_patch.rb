# encoding: utf-8
require 'redmine'
require 'wiki_content'

module PresentationWikiContentPatch
    def self.included(base)
        base.send(:include, InstanceMethodsForWikiContent)
    end
    
    module InstanceMethodsForWikiContent
        def slide_options
            @slide_options ||= SlideOptions.new
        end
        
        class SlideOptions
            attr_accessor :theme, :code_style, :transition, :speed
            attr_accessor :parallax_image, :parallax_image_size
            attr_accessor :background_color, :background_image, :background_size
            attr_accessor :background_position, :background_repeat, :background_transition
            
            def initialize
                @theme                 = 'league'
                @code_style            = 'default'
                @transition            = 'slide'
                @speed                 = 'normal'
                @parallax_image        = ''
                @parallax_image_size   = ''
                @background_size       = 'cover'
                @background_position   = 'center'
                @background_repeat     = 'no-repeat'
                @background_transition = ''
                @parallax_image        = ''
                @parallax_image_size   = ''
            end
        end
    end
end

WikiContent.send(:include, PresentationWikiContentPatch)
