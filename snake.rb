# The package that is rquired to make the application
require 'ruby2d'


# Setting the background to be black
# In order for a GUI to show up xLaunch was installed
set background: 'black'
set fps_cap: 15

# W x H = 640 * 480

GRID_SIZE = 20
GIRD_WIDTH = Window.width / GRID_SIZE
GIRD_HEIGHT = Window.height / GRID_SIZE

class Snake
    attr_writer :direction

    def initialize
        @positions = [[2,0],[2,1],[2,2],[2,3]]
        @direction = 'down'
    end

    def draw
        @positions.each do |position|
            Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE-1, color: "white")
        end
    end

    def move
        @positions.shift
        case @direction
        when 'down'
            @positions.push(newCoords(head[0], head[1] + 1))
        when 'up'
            @positions.push(newCoords(head[0], head[1] - 1))
        when 'left'
            @positions.push(newCoords(head[0] - 1, head[1]))
        when 'right'
            @positions.push(newCoords(head[0] + 1, head[1]))
        end
    end

    def canChangeDirectionTo?(newDirection)
        case @direction
        when 'up' then newDirection != 'down'
        when 'down' then newDirection != 'up'
        when 'right' then newDirection != 'left'
        when 'left' then newDirection != 'right'
        end
    end

    private

    def head
        @positions.last
    end

    def newCoords(x,y)
        [x % GIRD_WIDTH, y % GIRD_HEIGHT]
    end

end

snake = Snake.new

update do
    clear

    snake.move
    snake.draw
end

on :key_down do |event|
 if ['up','down','left','right'].include?(event.key)
    if snake.canChangeDirectionTo?(event.key)
        snake.direction = event.key
    end
  end
end

show