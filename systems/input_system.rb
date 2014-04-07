class InputSystem < Artemis::EntityProcessingSystem
    def initialize(screen)
        super(Artemis::Aspect.new_for_all StaticDisplay, Grid, BoardPosition)
        @screen = screen
    end

    def setup
        @dm = Artemis::ComponentMapper.new(StaticDisplay, @world)
        @gm = Artemis::ComponentMapper.new(Grid, @world)
        @pm = Artemis::ComponentMapper.new(BoardPosition, @world)
    end

    def process_entity(e)
        display = @dm.get(e)
        grid = @gm.get(e)
        position = @pm.get(e)

        if display && grid
            while input = @screen.getch
                case input
                when Curses::KEY_RIGHT
                    move_selector(display, position, 1)
                when Curses::KEY_LEFT
                    move_selector(display, position, -1)
                when 10, ' ' # ENTER or SPACE
                    drop_piece(display, grid, position)
                when 'q', 'Q'
                    abort
                end
            end
        end
    end

    def move_selector(display, position, direction)
        width = BOARD_WIDTH

        position.x += direction
        if position.x < 0
            position.x = width - 1
        elsif position.x > width - 1
            position.x = 0
        end

        start_x  = (Curses.cols - 4 - (width * 3)) / 2 + 2
        display.screen_x = start_x + position.x * 3
    end

    def drop_piece(display, grid, position)
        @player = @player == 1 ? 2 : 1

        piece_x = display.screen_x + 1
        col = position.x
        col_size = grid.pieces[col].length
        space_remaining = BOARD_HEIGHT - col_size

        if space_remaining > 0
            piece_y = display.screen_y + space_remaining
            EntityFactory.create_piece(@world, @player, piece_x, piece_y).add_to_world
            grid.pieces[col] << @player
        end
        check_score(grid, col)
    end

    def check_score(grid, col)
        full = true
        grid.pieces.each do |column|
            if column.length < BOARD_HEIGHT
                full = false
                break
            end
        end
        end_game('TIE GAME') if full
    end

    def end_game(msg)
        x = (Curses.cols - 4) / 2
        y = (Curses.lines - 4 - msg.length) / 2

        @screen.clear
        @screen.setpos(y, x)
        @screen.addstr(msg)
        @screen.refresh
        sleep(2)

        abort(msg)
    end
end
