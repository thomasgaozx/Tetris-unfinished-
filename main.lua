tetromino=require "tetromino"

function love.load()
	unit=25 -- in pixel
	love.graphics.setBackgroundColor(250,250,250)
    
	--PLAYSPACE initialization
	centerPoint={}
	centerPoint.cpx=love.graphics.getWidth()/2
	centerPoint.cpy=love.graphics.getHeight()/2
	playSpace={width=8*unit, height=18*unit} -- PLAYSPACE SIZE
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
	newTetromino=tetromino.generateTetromino(math.floor(playSpace.width/(2*unit))-1,0)

    --GAME SETTING
	incrementTime=0
	incrementMove=0
	freezeCounter=0
	legalMove=true
	blockImage=love.graphics.newImage('TetrisUnit.png')
	stage="checkEnd"
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
        if newTetromino[5] ~= 'O' then
			centralBlock=newTetromino[1]
			x0=centralBlock.x
			y0=centralBlock.y
			for i=2,4 do
				block=newTetromino[i]
				xi=block.x
				yi=block.y
				newblockx , newblocky = x0-y0+yi , y0+x0-xi
				if newblockx<0 or newblockx>playSpace.width-1 or newblocky>playSpace.height-1 or grid[newblockx][newblocky]==true then
					legalMove=false
					break
				end
			end
		end
		if legalMove then
			tetromino.rotate(newTetromino)
		end
		legalMove=true
	end
end


function love.update(dt)
	if stage=="checkEnd" and tetromino.reachEnd(newTetromino,grid,playSpace) then
		--TO DO: Check whether need to eliminate one row and move everything down by one
		
		freezeCounter=freezeCounter+dt
		incrementTime=incrementTime-dt
		incrementMove=incrementMove-dt
		if freezeCounter>=0.4 then
			freezeCounter=0
			for i=1,4 do
				block=newTetromino[i]
				grid[block.x][block.y]=true
			end
			stage="checkRow"			
		end
	end

	if stage=="checkRow" then-- checkRow legal then eliminate row else generate new tetromino
		for row=0,(playSpace.height/unit-1) do
			if tetromino.shouldEliminate(row,grid,playSpace) then
				tetromino.moveRow(row,grid,playSpace)
			end
		stage="checkEnd"
		newTetromino=tetromino.generateTetromino(math.floor(playSpace.width/(2*unit))-1,0)
		end
	end
	-------------------------------------------------------------------

	incrementTime=incrementTime+dt
	incrementMove=incrementMove+dt
	if love.keyboard.isDown('down') and incrementMove>=0.01 then
		incrementMove=0
		if not tetromino.reachEnd(newTetromino,grid,playSpace) then
			tetromino.updateTetromino(newTetromino,0,1)
		end
	end

	if incrementTime>0.7 then
		incrementTime=0
		if not tetromino.reachEnd(newTetromino,grid,playSpace) then
			tetromino.updateTetromino(newTetromino,0,1)
		end
		freezeCounter=0
	end
end

function love.draw()
	--draw PLAY SPACE
	love.graphics.setColor(200,1250,200)
	love.graphics.rectangle('fill',playSpace.leftBound, playSpace.upperBound, playSpace.width, playSpace.height)
	
	--draw TETROMINO
	love.graphics.setColor(0, 400, 0)
	tetromino.drawTetromino(newTetromino, grid)

	--draw TRUE GRID
	love.graphics.push()
	love.graphics.translate(playSpace.leftBound, playSpace.upperBound)
	for x = 0,(playSpace.width/unit-1) do
		for y = 0,(playSpace.height/unit-1) do
			if grid[x][y] then
				love.graphics.draw(blockImage, x*unit, y*unit)
			end
		end
	end
	love.graphics.pop()
end
