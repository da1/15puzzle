///<reference path="../lib/typescript-underscore/underscore.browser.d.ts" />
///<reference path="../lib/jquery.d.ts/jquery.d.ts" />
interface Point {
    x: number;
    y: number;
}

class Panel {
    panelSize : number;
    panel : number[];

    constructor(size:number) {
        this.panelSize = size;
        this.panel = [];
        for(var i=0;i<size*size;i++){
            this.panel[i] = i;
        }
    }

    getPanelLength() : number {
        return this.panel.length;
    }
    getPanelValue(index:number) : number {
        return this.panel[index];
    }
    index2Point(index:number) : Point {
        var x = index % this.panelSize;
        var y = Math.floor(index/this.panelSize);
        return {x:x, y:y};
    }
    point2Index(p:Point) : number {
        return this.panelSize * p.y + p.x;
    }
    shufflePanels() {
        this.panel = [];
        for(var i=1;i<this.panelSize*this.panelSize;i++){
            this.panel[i-1] = i;
        }
        this.panel = _.shuffle(this.panel);
        this.panel.push(0);
    }
    swap(index:number) : number {
        var p = this.index2Point(index);
        var ret = -1;
        [{x:p.x-1,y:p.y}, {x:p.x+1,y:p.y}, {x:p.x,y:p.y-1}, {x:p.x,y:p.y+1}].forEach((n) => {
            if(this.canMovePanel(n)){
                this.swapPanel(index, this.point2Index(n));
                if(ret == -1) {
                    ret = this.point2Index(n);
                }
            }
        });
        return ret;
    }
    canMovePanel(point:Point) : bool {
        if(point.x < 0 || point.y < 0) {
            return false ;
        }
        if(point.x >= this.panelSize || point.y >= this.panelSize) {
            return false;
        }
        if(this.panel[this.point2Index(point)] != 0) {
            return false;
        }
        return true;
    }
    swapPanel(p1:number, p2:number) {
        var buf = this.panel[p1];
        this.panel[p1] = this.panel[p2];
        this.panel[p2] = buf;
    }
}

module puzzle {
    export function setPanelClickEvent(panel:Panel) {
        $("div#mesh ul li").click((e) => {
            var index = $(e.target).index();
            var p = panel.swap(index);
            if(p>=0) {
                swapPanel(index, p);
            }
        });
    }

    function swapPanel(p1:number, p2:number) {
        var value1 = $("div#mesh ul li").eq(p1).text()
        var value2 = $("div#mesh ul li").eq(p2).text()
        $("div#mesh ul li").eq(p1).text(value2)
        $("div#mesh ul li").eq(p2).text(value1)
    }

    export function view(panel:Panel) {
        for(var i=0;i<panel.getPanelLength();i++){
            var value = panel.getPanelValue(i).toString();
            if(value == "0"){
                value = "";
            }
            $("div#mesh ul li").eq(i).text(value);
        }
    }
}

$(() => {
    var panel = new Panel(4);
    panel.shufflePanels();
    puzzle.setPanelClickEvent(panel)
    puzzle.view(panel);

    $("#reset").click(() => {
        panel.shufflePanels();
        puzzle.view(panel);
    });
});
