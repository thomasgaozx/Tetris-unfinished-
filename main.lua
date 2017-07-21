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
			grid[x][y] = false
		end
	end

    --TETROMINO initialization
	newTetromino=tetromino.generateTetromino(2,0)

    --GAME SETTING
	incrementTime=0
	incrementMove=0
	legalMove=true

end

function love.keypressed(key)
	if key == "right" then
		for i=1,4 do
			block=newTetromino[i]
			if ((block.x)+1)>(playSpace.width/unit-1) then
				legalMove=false
				break
			elseif((block.x)+1)<=(playSpace.width/unit-1) then
				if grid[block.x+1][block.y] then
					legalMove=false
					break
				end
			end
		end
		if legalMove then
			tetromino.updateTetromino(newTetromino,1,0)
		end
		legalMove=true
	end

	if key == "left" then
		for i=1,4 do
			block=newTetromino[i]
			if ((block.x)-1)<0 then
				legalMove=false
				break
			elseif((block.x)-1)>=0 then
				if grid[block.x-1][block.y] then
					legalMove=false
					break
				end
			end
		end
		if legalMove then
			tetromino.updateTetromino(newTetromino,-1,0)
		end
		legalMove=true
	end

	if key == "up" then
		tetromino.rotate(newTetromino)
	end
end


function love.update(dt)
	if tetromino.reachEnd(newTetromino,grid,playSpace) then
		newTetromino=tetromino.generateTetromino(2,0)
	end

	incrementTime=incrementTime+dt
	incrementMove=incrementMove+dt
	if love.keyboard.isDown('down') and incrementMove>=0.1 then
		incrementMove=0
		tetromino.updateTetromino(newTetromino,0,1)
	end

	if incrementTime>0.7 then
		incrementTime=0
		tetromino.updateTetromino(newTetromino,0,1)
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
