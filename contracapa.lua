local composer = require( "composer" )
local scene = composer.newScene()
local MARGIN = 40

local backgroundSound 
local isSoundOn = false 
 
function scene:create( event )
    local sceneGroup = self.view

    local background = display.newImageRect(sceneGroup, "assets/contracapa/Contracapa.png", 768, 1024)

    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local pa = display.newImage(sceneGroup, "/assets/botoes/pa.png")
    pa.x = display.contentWidth - pa.width/2 - MARGIN - 500
    pa.y = display.contentHeight - pa.height/2 - MARGIN

    pa:addEventListener("tap", function()
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("contracapa")
        composer.gotoScene("pagina6", {
            effect = "slideRight",
            time = 500
        });
        
    end)

    local vi = display.newImage(sceneGroup, "/assets/botoes/vi.png")
    vi.x = display.contentWidth - vi.width/2 - MARGIN
    vi.y = display.contentHeight - vi.height/2 - MARGIN

    vi:addEventListener("tap", function()
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("contracapa")
        composer.gotoScene("capa", {
            effect = "slideRight",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "/assets/botoes/som.png")
    som.x = display.contentWidth - som.width / 2 - 520
    som.y = display.contentHeight - som.height / 2 - 900

    backgroundSound = audio.loadStream("audios/contracapa.mp3")

    
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
 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene