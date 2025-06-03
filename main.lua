-- Window size set karne ke liye
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

-- Paddles ko set karne ke liye
PADDLE_SPEED = 300
PADDLE_WIDTH = 10
PADDLE_HEIGHT = 100

-- Ball properties
BALL_SIZE = 10

function love.load()
    love.window.setTitle("2-Player Ping Pong")
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)

    player1Y = WINDOW_HEIGHT / 2 - PADDLE_HEIGHT / 2
    player2Y = player1Y

    ballX = WINDOW_WIDTH / 2 - BALL_SIZE / 2
    ballY = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
    ballDX = math.random(2) == 1 and 200 or -200
    ballDY = math.random(-50, 50)

    -- Initial Scores zero honge
    player1Score = 0
    player2Score = 0
end

function love.update(dt)
    -- Player 1 (W/S)
    if love.keyboard.isDown("w") then
        player1Y = math.max(0, player1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("s") then
        player1Y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player1Y + PADDLE_SPEED * dt)
    end

    -- Player 2 (Up/Down)
    if love.keyboard.isDown("up") then
        player2Y = math.max(0, player2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("down") then
        player2Y = math.min(WINDOW_HEIGHT - PADDLE_HEIGHT, player2Y + PADDLE_SPEED * dt)
    end

    -- Ball movement
    ballX = ballX + ballDX * dt
    ballY = ballY + ballDY * dt

    -- Ball collision with top/bottom walls
    if ballY <= 0 or ballY + BALL_SIZE >= WINDOW_HEIGHT then
        ballDY = -ballDY
    end

    -- Ball collision with paddles
    if ballX <= 20 and ballY + BALL_SIZE >= player1Y and ballY <= player1Y + PADDLE_HEIGHT then
        ballDX = -ballDX
        ballX = 20
    elseif ballX + BALL_SIZE >= WINDOW_WIDTH - 20 and ballY + BALL_SIZE >= player2Y and ballY <= player2Y + PADDLE_HEIGHT then
        ballDX = -ballDX
        ballX = WINDOW_WIDTH - 20 - BALL_SIZE
    end

    -- Scoring logic ye hoga
    if ballX < 0 then
        player2Score = player2Score + 1
        resetBall()
    elseif ballX > WINDOW_WIDTH then
        player1Score = player1Score + 1
        resetBall()
    end
end

function resetBall()
    ballX = WINDOW_WIDTH / 2 - BALL_SIZE / 2
    ballY = WINDOW_HEIGHT / 2 - BALL_SIZE / 2
    ballDX = math.random(2) == 1 and 200 or -200
    ballDY = math.random(-50, 50)
end

function love.draw()
    -- Background
    love.graphics.clear(0.1, 0.1, 0.1)

    -- Paddles
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 10, player1Y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle("fill", WINDOW_WIDTH - 20, player2Y, PADDLE_WIDTH, PADDLE_HEIGHT)

    -- Ball
    love.graphics.rectangle("fill", ballX, ballY, BALL_SIZE, BALL_SIZE)

    -- Scores
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print(tostring(player1Score), WINDOW_WIDTH / 2 - 60, 20)
    love.graphics.print(tostring(player2Score), WINDOW_WIDTH / 2 + 40, 20)
end
