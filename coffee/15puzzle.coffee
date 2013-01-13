class Panel
    constructor: (size=4)->
        @panelSize = size
        @panel = [0...@panelSize * @panelSize]
    getPanelLength: ->
        return @panel.length
    getPanelValue: (index) ->
        return @panel[index]
    index2Point: (index) ->
        x = index % @panelSize
        y = Math.floor(index / @panelSize)
        return [x,y]
    point2Index: (x,y) ->
        return @panelSize * y + x
    shufflePanels: ->
        @panel = [1...@panelSize*@panelSize]
        @panel = _.shuffle(@panel)
        @panel.push(0)
    swap: (p) ->
        [x,y] = @index2Point(p)
        for [tx,ty] in [[x-1,y], [x+1,y], [x,y-1], [x,y+1]]
            if (@canMovePanel(tx, ty))
                @swapPanel(p, @point2Index(tx,ty))
                return @point2Index(tx,ty)
        return -1

    canMovePanel: (x,y) ->
        return false if x < 0 || y < 0
        return false if x >= @panelSize || y >= @panelSize
        return false if @panel[@point2Index(x,y)] != 0
        return true
    swapPanel: (p1, p2) ->
        [@panel[p1],@panel[p2]] = [@panel[p2],@panel[p1]]

$ ->
    setPanelClickEvent = ->
        $("div#mesh ul li").click ->
            index = $("div#mesh ul li").index(@)
            p = panel.swap(index)
            swapPanel(index, p) if p >= 0
    swapPanel = (p1, p2) ->
        value1 = $("div#mesh ul li").eq(p1).text()
        value2 = $("div#mesh ul li").eq(p2).text()
        $("div#mesh ul li").eq(p1).text(value2)
        $("div#mesh ul li").eq(p2).text(value1)
    view = ->
        for i in [0...panel.getPanelLength()]
            value = panel.getPanelValue(i)
            $("div#mesh ul li").eq(i).text(if value==0 then "" else value)

    panel = new Panel()
    panel.shufflePanels()
    setPanelClickEvent()
    view()

    $("#reset").click (e)->
        panel.shufflePanels()
        view()
