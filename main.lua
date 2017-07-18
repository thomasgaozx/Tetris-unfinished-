tetromino=require "tetromino"

function love.load()
	unit=25 -- in pixel
	love.graphics.setBackgroundColor(250,250,250)
    
	--PLAYSPACE initialization
	centerPoint={}
    centerPoint.cpx=love.graphics.getWidth()/2
    centerPoint.cpy=love.graphics.getHeight()/2
    playSpace={width=6*unit, height=10*unit} -- PLAYSPACE SIZE
    playSpace.leftBound=centerPoint.cpx-playSpace.width/2 -- x
    playSpace.rightBound=centerPoint.cpx+playSpace.width/2 -- x
    playSpace.upperBound=centerPoint.cpy-playSpace.height/2 --y
    playSpace.ground=centerPoint.cpy+playSpace.height/2 -- y

    --GRID initialization
    grid={}
	for x = 0,(playSpace.width/unit-1) do
		grid[x]={}
		for y = 0,(playSpace.height/unit-1) do
			grid[x][y] = {isFill = false}
		end
	end

    --TETROMINO initialization
    newTetromino=tetromino.generateTetromino(3,1)

    --GAME SETTING
    incrementTime=0

end

function love.keypressed(key)
	if key == "down" then
        tetrisBlock.y=tetrisBlock.y+1
    end  

    if key == "left" then
    	tetrisBlock.x=tetrisBlock.x-1
    end

    if key == "right" then
    	tetrisBlock.x=tetrisBlock.x+1
    end 
end


function love.update(dt)
	incrementTime=incrementTime+dt
	if incrementTime>0.7 then
		incrementTime=0
		tetromino.updateTetromino(newTetromino,0,1)
		if tetromino.reachEnd(newTetromino,grid,playSpace) then
			newTetromino=generateTetromino(3,1)
	    end
	end
end

function love.draw()
   
	--draw PLAY SPACE
	love.graphics.setColor(200,1250,200)
	love.graphics.rectangle('fill',playSpace.leftBound, playSpace.upperBound, playSpace.width, playSpace.height)
    
    --draw TETRIS UNIT
    love.graphics.setColor(0, 400, 0)
    tetromino.drawTetromino(newTetromino, grid)
 
end
