$ ->
    panelSize = 4
    index2Point = (index) ->
        x = index % panelSize
        y = Math.floor(index / panelSize)
        return [x,y]
    point2Index = (x,y) ->
        return panelSize * y + x

    init = ->
        initPanels()
        $("#reset").click (e)->
            setPanels()
    initPanels = ->
        setPanels()
        setPanelClickEvent()

    setPanels = ->
        maxIndex = panelSize * panelSize
        list = _.shuffle([1...maxIndex])
        for num in [0...maxIndex-1]
            $("div#mesh ul li").eq(num).text(list[num])

    setPanelClickEvent = ->
        $("div#mesh ul li").click ->
            index = $("div#mesh ul li").index(@)
            [x,y] = index2Point(index)
            for [px,py] in [[x-1,y], [x+1,y], [x,y-1], [x,y+1]]
                if (canMovePanel(px, py))
                    swapPanel(index, point2Index(px,py))
                    return

    canMovePanel = (x,y) ->
        return false if x < 0 || y < 0
        return false if x >= panelSize || y >= panelSize
        return false if getPanelValue(x,y) != ""
        return true

    getPanelValue = (x, y) ->
        return $("div#mesh ul li").eq(point2Index(x,y)).text()

    swapPanel = (p1, p2) ->
        value1 = $("div#mesh ul li").eq(p1).text()
        value2 = $("div#mesh ul li").eq(p2).text()
        $("div#mesh ul li").eq(p1).text(value2)
        $("div#mesh ul li").eq(p2).text(value1)

    init()
