local composer = require("composer")
local scene = composer.newScene()
local MARGIN = 30

local backgroundSound 
local isSoundOn = false 

local clickCounts = { areia1 = 0, areia2 = 0, areia3 = 0 } 

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/p4/p4.png", 768, 1024)
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
        composer.removeScene("pagina4")
        composer.gotoScene("pagina5", {
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
        composer.removeScene("pagina4")
        composer.gotoScene("pagina3", {
            effect = "slideRight",
            time = 500
        })
    end)

    local areia1 = display.newImage(sceneGroup, "assets/p4/areia.png")
    areia1.x, areia1.y = 638, 388
    areia1.id = "areia1"

    local areia2 = display.newImage(sceneGroup, "assets/p4/areia.png")
    areia2.x, areia2.y = 120, 606
    areia2.id = "areia2"

    local areia3 = display.newImage(sceneGroup, "assets/p4/areia.png")
    areia3.x, areia3.y = 642, 816
    areia3.id = "areia3"

    local function criarAreia(x, y)
        local particle = display.newCircle(sceneGroup, x, y, 2) 
        particle:setFillColor(0.8, 0.6, 0.5)

        local angle = math.random() * 2 * math.pi 
        local distance = math.random(30, 100) 
        local targetX = x + math.cos(angle) * distance
        local targetY = y + math.sin(angle) * distance

        transition.to(particle, {
            x = targetX,
            y = targetY,
            time = 500,
            onComplete = function()
                particle:removeSelf()
            end
        })
    end

    local function onAreiaTapped(event)
        local areia = event.target
        local centerX, centerY = areia.x, areia.y

        clickCounts[areia.id] = clickCounts[areia.id] + 1

        for i = 1, 300 do
            criarAreia(centerX, centerY)
        end

        if clickCounts[areia.id] == 5 then
            if areia.id == "areia1" then
                local newImage1 = display.newImage(sceneGroup, "/assets/p4/cranio.png")
                newImage1.x, newImage1.y = centerX, centerY - 30

                local newImage2 = display.newImage(sceneGroup, "/assets/p4/mandibula.png")
                newImage2.x, newImage2.y = centerX + 20, centerY + 30

            elseif areia.id == "areia2" then
                local newImage1 = display.newImage(sceneGroup, "/assets/p4/ferramentas.png")
                newImage1.x, newImage1.y = centerX, centerY

            elseif areia.id == "areia3" then
                local newImage1 = display.newImage(sceneGroup, "/assets/p4/roupas.png")
                newImage1.x, newImage1.y = centerX, centerY 
            end

           
            areia:removeEventListener("tap", onAreiaTapped)
        end
    end

    local som = display.newImage(sceneGroup, "/assets/botoes/som.png")
    som.x = display.contentWidth - som.width / 2 - 515
    som.y = display.contentHeight - som.height / 2 - 920

    backgroundSound = audio.loadStream("audios/p4.mp3")

    
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

    areia1:addEventListener("tap", onAreiaTapped)
    areia2:addEventListener("tap", onAreiaTapped)
    areia3:addEventListener("tap", onAreiaTapped)
end
 
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if not isSoundOn then
            audio.play(backgroundSound, { loops = -1 })
            isSoundOn = true
        end
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
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

