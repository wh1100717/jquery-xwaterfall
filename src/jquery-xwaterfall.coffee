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
    }

    class WaterFall
        constructor: (@container, @options) ->
        init: ->
            @page = 1
            @unloadNum = 0
            @loading = false
            @colNum = @container.width() / @options.width
            @colWidths = (i * @options.width for i in [0...@colNum])
            @colHeights = (0 for i in [0...@colNum])
            console.log @colHeights
            console.log @colNum
            self = @
            loadData =  ->
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
            $(window).bind("scroll", loadData)
        generate: (data) ->
            self = @
            tpl = ""
            for d in data
                tpl += """
                    <li style="left: #{@random(6000)}px; top: #{@random(6000)}px;">
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
            console.log minHeigth
            node.animate {
                top: minHeigth
                left: @colWidths[minIndex]
            }
            @container.css("height", Math.max.apply({}, @colHeights))
            @unloadNum -= 1
        random: (number) -> Math.floor(Math.random() * number)

    return
)(jQuery)