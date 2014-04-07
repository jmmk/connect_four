#!/usr/bin/env ruby

require 'artemis'
require 'curses'

require_relative 'entity_factory'

require_relative 'systems/static_render_system'
require_relative 'systems/input_system'

class ConnectFour

    def initialize
        Curses.init_screen
        Curses.cbreak
        Curses.noecho
        Curses.curs_set(0) # hide cursor

        @screen = Curses.stdscr
        @screen.nodelay = true
        @screen.keypad = true

        @world = Artemis::World.new

        @world.add_manager(Artemis::GroupManager.new)

        @world.set_system(InputSystem.new(@screen)).setup
        @world.set_system(StaticRenderSystem.new(@screen)).setup

        EntityFactory.create_title(@world).add_to_world
        EntityFactory.create_board(@world).add_to_world
        EntityFactory.create_selection(@world).add_to_world
    end

    def start
        current_time = Time.now
        loop do # event
            elapsed_time = Time.now - current_time
            if elapsed_time >= 1.0 / 30 # FPS
                current_time = Time.now
                @world.delta = elapsed_time
                @world.process
            end
        end
        Curses.close_screen
    end
end

ConnectFour.new.start
