# The package that is rquired to make the application
require 'ruby2d'


# Setting the background to be black
# In order for a GUI to show up xLaunch was installed
set background: 'black'
set fps_cap: 15
set title: "Snake"

# W x H = 640 * 480

GRID_SIZE = 20
GIRD_WIDTH = Window.width / GRID_SIZE
GIRD_HEIGHT = Window.height / GRID_SIZE

class Snake
    attr_writer :direction

    def initialize
        @positions = [[2,0],[2,1],[2,2],[2,3]]
        @direction = 'down'
        @growing = false
    end

    def draw
        @positions.each do |position|
            Square.new(x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE-1, color: "white")
        end
    end

    def move
        if !@growing
            @positions.shift
        end
        
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
        @growing = false
    end

    def canChangeDirectionTo?(newDirection)
        case @direction
        when 'up' then newDirection != 'down'
        when 'down' then newDirection != 'up'
        when 'right' then newDirection != 'left'
        when 'left' then newDirection != 'right'
        end
    end

    def x
        head[0]
    end

    def y
        head[1]
    end

    def grow 
        @growing = true
    end

    def hitItself?
        @positions.uniq.length != @positions.length
    end

    private

    def newCoords(x,y)
        [x % GIRD_WIDTH, y % GIRD_HEIGHT]
    end

    def head
        @positions.last
    end
end

class Game
    def initialize
        @score = 0
        @foodX = rand(GIRD_WIDTH)
        @foodY = rand(GIRD_HEIGHT)
        @finished = false
    end 

    def draw
        unless finished?
            Square.new(x: @foodX * GRID_SIZE, y: @foodY * GRID_SIZE, size: GRID_SIZE, color: 'yellow')
        end

        Text.new(message, color: "green", x: 10, y: 10, size: 25)
    end

    def snakeHitFood?(x, y)
        @foodX == x && @foodY == y
    end

    def recordHit
        @score += 1
        @foodX = rand(GIRD_WIDTH)
        @foodY = rand(GIRD_HEIGHT)
    end

    def finish
        @finished = true
    end

    def finished?
        @finished
    end

    private

    def message
        if finished?
            "Game Over, your Score was: #{@score}. Press 'R' to Restart"
        else
            "Score: #{@score}"
        end
    end
end


snake = Snake.new
game = Game.new

update do
    clear

    unless game.finished?
        snake.move
    end
    
    snake.draw
    game.draw

    if game.snakeHitFood?(snake.x, snake.y)
        game.recordHit
        snake.grow
    end

    if snake.hitItself?
        game.finish
    end
end

on :key_down do |event|
 if ['up','down','left','right'].include?(event.key)
    if snake.canChangeDirectionTo?(event.key)
        snake.direction = event.key
    end
elsif event.key == 'r'
    snake = Snake.new
    game = Game.new
  end
end

show