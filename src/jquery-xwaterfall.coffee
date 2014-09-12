###
 * jquery-xwaterfall
 *
 *
 * Copyright (c) 2014 wh1100717, somonus
 * Licensed under the MIT license.
###

(($) ->
    $.fn.waterfall = (options) ->
        options = $.extend({}, $.waterfall.options, options)
        wf = new WaterFall @, options
        wf.init()
    $.waterfall = (options) ->
        options = $.extend({}, $.waterfall.options, options)
    $.waterfall.options = {
        width: 335
        ### Support Animate Effect
         *  flyIn
         *  fadeIn
         *  none
        ###
        animate: 'fadeIn'
    }

    class WaterFall
        constructor: (@container, @options) ->
        init: ->
            @page = 1
            @unloadNum = 0
            @loading = false
            @colNum = Math.floor(@container.width() / @options.width)
            @colWidths = (i * @options.width for i in [0...@colNum])
            @colHeights = (0 for i in [0...@colNum])
            self = @
            $(window).bind("scroll", -> self.loadData(self))
            $(window).resize -> self.resize(self)
        loadData: (self) ->
            return if self.unloadNum > 0
            return if self.loading
            win = $(window)
            winTop = win.scrollTop() + win.height()
            absTop = self.container.offset().top + self.container.height()
            return if winTop < absTop - 2 * win.height()
            self.loading = true
            $.getJSON self.options.url, {page: self.page}, (data)->
                return if not data?
                self.generate(data)
                self.unloadNum += data.length
                self.page += 1
                self.loading = false
            return @
        resize: (self) ->
            newcolNum = Math.floor(@container.width() / @options.width)
            console.log newcolNum
            console.log @colNum
            return if newcolNum is @colNum
            @colNum = newcolNum
            @colWidths = (i * @options.width for i in [0...@colNum])
            @colHeights = (0 for i in [0...@colNum])
            wrappers = $("#waterfall li")
            wrappers.each ->
                self.insert($(@))
        generate: (data) ->
            self = @
            tpl = ""
            for d in data
                tpl += """
                    <li style="left: #{@random(@container.width()*2)}px; top: #{@random(@container.height()*2)}px; display:none;">
                        <a href="javascript:void(0)">
                            <img src="#{d.isrc}" width="#{@options.width}">
                        </a>
                    </li>
                """
            wrappers = $(tpl)
            @container.append(wrappers)
            wrappers.find("img").each ->
                $(@).load ->
                    node = $(@).parents("li")
                    self.insert(node)
        insert: (node) ->
            minHeigth = Math.min.apply({}, @colHeights)
            for i, index in @colHeights when i is minHeigth
                minIndex = index
                break
            @colHeights[minIndex] += node.height()
            if @options.animate is 'flyIn'
                node.show()
                node.animate {
                    top: minHeigth
                    left: @colWidths[minIndex]
                },500
            else if @options.animate is 'fadeIn'
                node.css("top", minHeigth)
                node.css("left", @colWidths[minIndex])
                node.fadeIn(500)                
            else
                node.css("top", minHeigth)
                node.css("left", @colWidths[minIndex])
                node.show()
            @container.css("height", Math.max.apply({}, @colHeights))
            @unloadNum -= 1
        random: (number) -> Math.floor(Math.random() * number)

    return
)(jQuery)