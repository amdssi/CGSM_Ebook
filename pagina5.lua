local composer = require("composer")
local scene = composer.newScene()
local MARGIN = 40

local backgroundSound
local isSoundOn = false
local simulationTimer
local accelerometerListenerAdded = false 

local sequence = 1
local sapiensGroup = {}
local neandGroup = {}

local function updateImages(direction)
    local step = direction > 0 and 1 or -1
    sequence = sequence + step

    if sequence > 5 then
        sequence = 1
    elseif sequence < 1 then
        sequence = 5
    end

    for i = 1, 5 do
        sapiensGroup[i].isVisible = (i == sequence)
        neandGroup[i].isVisible = (i == sequence)
    end
end

local function simulateAccelerometerEvent()
    local simulationValue = -0.5
    local simulationIncrement = 0.1

    return function()
        simulationValue = simulationValue + simulationIncrement

        if simulationValue > 1 or simulationValue < -1 then
            simulationIncrement = -simulationIncrement
        end

        if simulationValue > 0.2 then
            updateImages(1)
        elseif simulationValue < -0.2 then
            updateImages(-1)
        end
    end
end

local simulateAccelerometer

local function onAccelerometer(event)
    local xGravity = event.xGravity

    if xGravity > 0.2 then
        updateImages(1)
    elseif xGravity < -0.2 then
        updateImages(-1)
    end
end

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/p5/p5.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local pp = display.newImage(sceneGroup, "/assets/botoes/pp.png")
    pp.x = display.contentWidth - pp.width / 2 - MARGIN
    pp.y = display.contentHeight - pp.height / 2 - MARGIN

    pp:addEventListener("tap", function()
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pagina5")
        composer.gotoScene("pagina6", {
            effect = "slideLeft",
            time = 500
        })
    end)

    local pa = display.newImage(sceneGroup, "/assets/botoes/pa.png")
    pa.x = display.contentWidth - pa.width / 2 - MARGIN - 500
    pa.y = display.contentHeight - pa.height / 2 - MARGIN

    pa:addEventListener("tap", function()
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pagina5")
        composer.gotoScene("pagina4", {
            effect = "slideRight",
            time = 500
        })
    end)

    local centerX = display.contentCenterX
    local centerY = display.contentCenterY
    local sapiensImages = {
        "/assets/p5/sapiens1.png", "/assets/p5/sapiens2.png", "/assets/p5/sapiens3.png", "/assets/p5/sapiens4.png", "/assets/p5/sapiens5.png"
    }
    local neandImages = {
        "/assets/p5/neand1.png", "/assets/p5/neand2.png", "/assets/p5/neand3.png", "/assets/p5/neand4.png", "/assets/p5/neand5.png"
    }

    local sapiensXOffset = -150
    local neandXOffset = 150

    for i, image in ipairs(sapiensImages) do
        local sapiensImg = display.newImage(sceneGroup, image)
        sapiensImg.x = centerX + sapiensXOffset
        sapiensImg.y = centerY + 250
        sapiensImg.isVisible = (i == 1)
        table.insert(sapiensGroup, sapiensImg)

        local neandImg = display.newImage(sceneGroup, neandImages[i])
        neandImg.x = centerX + neandXOffset
        neandImg.y = centerY + 250
        neandImg.isVisible = (i == 1)
        table.insert(neandGroup, neandImg)
    end

    local som = display.newImage(sceneGroup, "/assets/botoes/som.png")
    som.x = display.contentWidth - som.width / 2 - 500
    som.y = display.contentHeight - som.height / 2 - 920

    backgroundSound = audio.loadStream("audios/p5.mp3")

    local function handleButtonTouch(event)
        if event.phase == "began" then
            local newImage
            if isSoundOn then
                audio.stop()
                isSoundOn = false
                newImage = display.newImage(sceneGroup, "/assets/botoes/semsSom.png")
            else
                audio.play(backgroundSound, { loops = -1 })
                isSoundOn = true
                newImage = display.newImage(sceneGroup, "/assets/botoes/som.png")
            end

            newImage.x = som.x
            newImage.y = som.y

            som:removeEventListener("touch", handleButtonTouch)
            som:removeSelf()
            som = nil

            som = newImage
            som:addEventListener("touch", handleButtonTouch)
        end
        return true
    end

    som:addEventListener("touch", handleButtonTouch)

    simulateAccelerometer = simulateAccelerometerEvent()
end

function scene:show(event)
    local phase = event.phase

    if phase == "did" then
        if not isSoundOn then
            audio.play(backgroundSound, { loops = -1 })
            isSoundOn = true
        end

        if not accelerometerListenerAdded then
            Runtime:addEventListener("accelerometer", onAccelerometer)
            accelerometerListenerAdded = true
        end

        simulationTimer = timer.performWithDelay(300, simulateAccelerometer, 0)
    end
end

function scene:hide(event)
    local phase = event.phase

    if phase == "will" then
        if accelerometerListenerAdded then
            Runtime:removeEventListener("accelerometer", onAccelerometer)
            accelerometerListenerAdded = false
        end

        if simulationTimer then
            timer.cancel(simulationTimer)
            simulationTimer = nil
        end
        if isSoundOn then
            audio.stop()
            isSoundOn = false
        end
    end
end

function scene:destroy(event)
    if backgroundSound then
        audio.dispose(backgroundSound)
        backgroundSound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
