local composer = require("composer")
local scene = composer.newScene()
local MARGIN = 40

local backgroundSound 
local isSoundOn = false 

function scene:create(event)
    local sceneGroup = self.view

    local objects = {}
    local targetAreas = {}
    local isPositioned = {}
    local isPopupOpen = false

    local function checkAllPositioned(sceneGroup)
        for _, positioned in ipairs(isPositioned) do
            if not positioned then
                return false
            end
        end

        if isPopupOpen then
            return true
        end

        isPopupOpen = true

        local popupGroup = display.newGroup()
        sceneGroup:insert(popupGroup)

        local popup = display.newImage(popupGroup, "assets/p2/pop up.png")
        popup.x = display.contentCenterX
        popup.y = display.contentCenterY

        local closeButton = display.newImage(popupGroup, "assets/p2/X.png")
        closeButton.x = popup.x + (popup.width / 2) - (closeButton.width / 2) - 40
        closeButton.y = popup.y - (popup.height / 2) + (closeButton.height / 2) + 40

        local function closePopup()
            if popupGroup then
                popupGroup:removeSelf()
                popupGroup = nil
                isPopupOpen = false
            end
        end

        closeButton:addEventListener("tap", closePopup)

        return true
    end

    local function createObject(sceneGroup, imagePath, x, y, targetX, targetY, index)
        local obj = display.newImage(sceneGroup, imagePath)
        obj.x = x
        obj.y = y
        table.insert(objects, obj)

        local target = display.newRect(sceneGroup, targetX, targetY, obj.width, obj.height)
        target.alpha = 0
        table.insert(targetAreas, target)

        isPositioned[index] = false

        local function dragObject(event)
            local obj = event.target

            if event.phase == "began" then
                display.getCurrentStage():setFocus(obj)
                obj.isFocus = true
                obj.touchOffsetX = event.x - obj.x
                obj.touchOffsetY = event.y - obj.y

            elseif obj.isFocus then
                if event.phase == "moved" then
                    obj.x = event.x - obj.touchOffsetX
                    obj.y = event.y - obj.touchOffsetY

                elseif event.phase == "ended" or event.phase == "cancelled" then
                    display.getCurrentStage():setFocus(nil)
                    obj.isFocus = false

                    if obj.x > target.x - target.width / 2 and obj.x < target.x + target.width / 2 and 
                       obj.y > target.y - target.height / 2 and obj.y < target.y + target.height / 2 then
                        obj.x = target.x
                        obj.y = target.y
                        isPositioned[index] = true
                        checkAllPositioned(sceneGroup)
                    else
                        isPositioned[index] = false
                    end
                end
            end
            return true
        end

        obj:addEventListener("touch", dragObject)
    end

    local background = display.newImageRect(sceneGroup, "assets/p2/p2.png", 768, 1024)
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
        composer.removeScene("pagina2")
        composer.gotoScene("pagina3", { effect = "slideLeft", time = 500 })
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
        composer.removeScene("pagina2")
        composer.gotoScene("capa", { effect = "slideRight", time = 500 })
    end)

    local som = display.newImage(sceneGroup, "/assets/botoes/som.png")
    som.x = display.contentWidth - som.width / 2 - 520
    som.y = display.contentHeight - som.height / 2 - 900

    backgroundSound = audio.loadStream("audios/p2.mp3")

    
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
    

    createObject(sceneGroup, "assets/p2/Bacia.png", 678, 206, 640, 518, 1)
    createObject(sceneGroup, "assets/p2/Braço direito.png", 452, 528, 704, 495, 2)
    createObject(sceneGroup, "assets/p2/Braço esquerdo.png", 726, 810, 510, 484, 3)
    createObject(sceneGroup, "assets/p2/Cabeca.png", 634, 540, 626, 230, 4)
    createObject(sceneGroup, "assets/p2/Costelas.png", 632, 716, 622, 386, 5)
    createObject(sceneGroup, "assets/p2/Coxa direita.png", 572, 338, 716, 582, 6)
    createObject(sceneGroup, "assets/p2/Perna esquerda.png", 706, 392, 556, 742, 7)
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
