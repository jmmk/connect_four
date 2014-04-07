class StaticRenderSystem < Artemis::EntityProcessingSystem
    def initialize(screen)
        super(Artemis::Aspect.new_for_all StaticDisplay)
        @screen = screen
    end

    def setup
        @dm = Artemis::ComponentMapper.new(StaticDisplay, @world)
    end

    def pre_process_entities
        @screen.clear
    end

    def process_entity(e)
        display = @dm.get(e)
        x = display.screen_x
        y = display.screen_y

        if display
            @screen.setpos(y, x)
            display.output.each do |str|
                @screen.addstr(str)
                y += 1
                @screen.setpos(y, x)
            end
        end
    end

    def post_process_entities
        @screen.refresh
    end
end
