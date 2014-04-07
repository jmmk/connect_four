require_relative 'constants'

require_relative 'components/static_display'
require_relative 'components/grid'
require_relative 'components/board_position'

class EntityFactory

    class << self
        def create_board(world)
            e = world.create_entity
            width = BOARD_WIDTH
            height = BOARD_HEIGHT

            board = []
            (0 .. height).each do |row|
                board[row] = ''
                board[row] << (row == height ? '|☐' : '| ')
                (1 .. width).each do
                    board[row] << (row == height ? '☐☐☐' : '   ')
                end
                board[row] << (row == height ? '☐|' : ' |')
            end

            display = StaticDisplay.new
            display.output = board
            display.screen_x = (Curses.cols - 4 - (width * 3)) / 2
            display.screen_y = (Curses.lines - 4) / 2
            e.add_component(display)

            return e
        end

        def create_title(world)
            e = world.create_entity

            title = [
                '   ______                            __     ______',
                '  / ____/___  ____  ____  ___  _____/ /_   / ____/___  __  _______',
                ' / /   / __ \\/ __ \\/ __ \\/ _ \\/ ___/ __/  / /_  / __ \\/ / / / ___/',
                '/ /___/ /_/ / / / / / / /  __/ /__/ /_   / __/ / /_/ / /_/ / /',
                '\\____/\\____/_/ /_/_/ /_/\\___/\\___/\\__/  /_/    \\____/\\__,_/_/'
            ]

            display = StaticDisplay.new
            display.output = title
            display.screen_x = (Curses.cols - 66) / 2
            display.screen_y = 0
            e.add_component(display)

            return e
        end

        def create_selection(world)
            e = world.create_entity
            width = BOARD_WIDTH
            height = BOARD_HEIGHT

            board_position = BoardPosition.new
            board_position.x = 0
            e.add_component(board_position)

            grid = Grid.new
            grid.width = width
            grid.height = height
            grid.pieces = []
            grid.width.times do |i|
                grid.pieces[i] = []
            end
            e.add_component(grid)

            display = StaticDisplay.new
            display.output = ['[ ]']
            display.screen_x = (Curses.cols - 4 - (width * 3)) / 2 + 2
            display.screen_y = (Curses.lines - 6) / 2
            e.add_component(display)

            return e
        end

        def create_piece(world, player, x, y)
            e = world.create_entity
            token = player == 1 ? ['X'] : ['O']

            display = StaticDisplay.new
            display.output = token
            display.screen_x = x
            display.screen_y = y
            e.add_component(display)

            return e
        end
    end
end
