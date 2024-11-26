local composer = require("composer")
local scene = composer.newScene()
local MARGIN = 40

local backgroundSound 
local isSoundOn = false 

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/p3/p3.png", 768, 1024)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local pp = display.newImage(sceneGroup, "assets/botoes/pp.png")
    pp.x = display.contentWidth - pp.width / 2 - MARGIN
    pp.y = display.contentHeight - pp.height / 2 - MARGIN

    pp:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pagina3")
        composer.gotoScene("pagina4", {
            effect = "slideLeft",
            time = 500
        })
    end)

    local pa = display.newImage(sceneGroup, "assets/botoes/pa.png")
    pa.x = display.contentWidth - pa.width / 2 - MARGIN - 500
    pa.y = display.contentHeight - pa.height / 2 - MARGIN

    pa:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pagina3")
        composer.gotoScene("pagina2", {
            effect = "slideRight",
            time = 500
        })
    end)

    local timelineWidth = display.contentWidth * 0.8
    local timelineHeight = 40
    local timelineX = display.contentCenterX
    local timelineY = display.contentHeight - 200
    local imageIndex = 1
    local images = {
        { mainImage = "assets/p3/darwinius.png", subImage = "assets/p3/darwiniusTexto.png" },
        { mainImage = "assets/p3/Lemure.png", subImage = "assets/p3/lemureTexto.png" },
        { mainImage = "assets/p3/tarsio.png", subImage = "assets/p3/tarsioTexto.png" },
        { mainImage = "assets/p3/macaco do novo mundo.png", subImage = "assets/p3/macacoNovoTexto.png" },
        { mainImage = "assets/p3/macaco do velho mundo.png", subImage = "assets/p3/macacoVelhoTexto.png" },
        { mainImage = "assets/p3/gibao.png", subImage = "assets/p3/gibaoTexto.png" },
        { mainImage = "assets/p3/orangotango.png", subImage = "assets/p3/orangotangoTexto.png" },
        { mainImage = "assets/p3/gorila.png", subImage = "assets/p3/gorilaTexto.png" },
        { mainImage = "assets/p3/chimpanze.png", subImage = "assets/p3/chimpanzeTexto.png" },
        { mainImage = "assets/p3/ser humano.png", subImage = "assets/p3/serHumanoTexto.png" },
    }
    local currentImage
    local currentSubImage

    local linha = display.newImage(sceneGroup, "assets/p3/linha.png")
    linha.x = display.contentCenterX + 75
    linha.y = display.contentCenterY + 100
    linha.isVisible = false 

    local linha2 = display.newImage(sceneGroup, "assets/p3/linha2.png")
    linha2.x = display.contentCenterX - 140
    linha2.y = display.contentCenterY + 100 
    linha2.isVisible = false

    local fixedImage

    local function updateContent(position)
        local newIndex = math.ceil((#images * position) / timelineWidth)
        if newIndex ~= imageIndex and images[newIndex] then
            local previousImage = currentImage
            local previousSubImage = currentSubImage
            imageIndex = newIndex
    
            currentImage = display.newImage(sceneGroup, images[imageIndex].mainImage)
            currentImage.x = display.contentCenterX + 50
            currentImage.y = display.contentCenterY + 120
            currentImage.alpha = 0
            currentImage:scale(0.5, 0.5)
    
            transition.to(currentImage, {
                time = 400,
                alpha = 1,
                xScale = 1,
                yScale = 1,
            })
    
            if currentSubImage then
                currentSubImage:removeSelf()
            end
            currentSubImage = display.newImage(sceneGroup, images[imageIndex].subImage)
            currentSubImage.x = display.contentCenterX
            currentSubImage.y = display.contentCenterY + 360

            if imageIndex == 1 then
                if fixedImage then
                    fixedImage:removeSelf()
                    fixedImage = nil
                end
            end
            
    
            if previousImage then
                transition.to(previousImage, {
                    time = 400,
                    x = 100,
                    y = 650,
                    xScale = 0.4,
                    yScale = 0.4,
                })
                if fixedImage then
                    fixedImage:removeSelf() 
                    fixedImage = nil 
                end
                fixedImage = previousImage
            end
    
            if imageIndex >= 2 and imageIndex <= 9 then
                linha.isVisible = true
                linha2.isVisible = false
            elseif imageIndex == 10 then
                linha.isVisible = false
                linha2.isVisible = true
            else
                linha.isVisible = false
            end
        end
    end
    

    local timeline = display.newImage(sceneGroup, "assets/p3/timeline.png")
    timeline.x = timelineX + 4
    timeline.y = timelineY - 30

    local ampulheta = display.newImage(sceneGroup, "assets/p3/ampulheta.png")
    ampulheta.x = timelineX / 5
    ampulheta.y = timelineY - 30

    local function dragListener(event)
        if event.phase == "began" then
            display.currentStage:setFocus(ampulheta)
        elseif event.phase == "moved" then
            local newX = math.max(timelineX - timelineWidth / 2, math.min(timelineX + timelineWidth / 2, event.x))
            ampulheta.x = newX
            updateContent(newX - (timelineX - timelineWidth / 2))
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.currentStage:setFocus(nil)
        end
        return true
    end

    ampulheta:addEventListener("touch", dragListener)

    currentImage = display.newImage(sceneGroup, images[1].mainImage)
    currentImage.x = display.contentCenterX
    currentImage.y = display.contentCenterY + 140

    currentSubImage = display.newImage(sceneGroup, images[1].subImage)
    currentSubImage.x = display.contentCenterX
    currentSubImage.y = display.contentCenterY + 360

    local som = display.newImage(sceneGroup, "/assets/botoes/som.png")
    som.x = display.contentWidth - som.width / 2 - 500
    som.y = display.contentHeight - som.height / 2 - 910

    backgroundSound = audio.loadStream("audios/p3.mp3")

    
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
