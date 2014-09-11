/*
 * jquery-xwaterfall
 *
 *
 * Copyright (c) 2014 wh1100717, somonus
 * Licensed under the MIT license.
 */

(function($) {

    fn = {
        options: {
            scrollSwitch: true,
            height: [],
            left: [],
            sortNum: 0
        },
        init: function(container) {
            var container = $(container);
            fn.initFall(container, "li");
            fn.go(container, "li");
            this.unloadNum = 0
        },
        go: function(target, child) {
            var loading = $(".loading"),
                page = target.attr('data-page') || 1,
                ajax = target.attr("data-ajax") || false,
                win = $(window);
            var i = 0;
            loadFn = function() {
                var winTop = win.scrollTop() + win.height(),
                    absTop = $(target).offset().top + $(target).height();
                if (winTop >= (absTop - 10) && fn.options.scrollSwitch && fn.unloadNum < 3) {
                    loading.show()
                    if (ajax) {
                        fn.options.scrollSwitch = false;
                        $.get(ajax, {
                            page: page
                        }, function(result) {
                            if (result) {
                                page++;
                                fn.process(target, result, child);
                                fn.options.scrollSwitch = true;
                            } else {
                                win.unbind('scroll', loadFn);
                            }
                            loading.hide();
                        });
                    } else {
                        return;
                    }
                }
            };
            win.bind('scroll', loadFn);
        },
        initFall: function(container, child) {
            var box = container.find(child),
                conW = container.width(),
                boxW = box.eq(0).width(),
                n = Math.floor(conW / boxW);
            for (var i = 0; i < n; i++) {
                fn.options.height[i] = 10;
                fn.options.left[i] = i * (boxW + 10);
            }
            box.each(function() {
                fn.sort(container, $(this), n);
            })
        },
        random: function(number) {
            return Math.floor(Math.random() * number);
        },
        process: function(container, result, child) {
            this.unloadNum += result.length
            var re = '';
            for (i = 0; i < result.length; i++) {
                re += '<li style="left:' + fn.random(6000) + 'px; top:' + fn.random(6000) + 'px"><a href=""><img src="' + result[i].isrc + '" width="200"></a></li>'
            }
            var s = $(re)
            container.append(s);
            $(s).find("img").each(function() {
                $(this).load(function() {
                    var node = $(this).parents(child);
                    fn.sort(container, node);
                    console.log(fn.unloadNum)
                    fn.unloadNum -= 1
                })
            })
        },
        sort: function(container, box, n) {
            var boxH = box.height();
            minH = Math.min.apply({}, fn.options.height);
            minKey = fn.getarraykey(fn.options.height, minH);
            fn.options.height[minKey] += boxH + 10;
            box.animate({
                "top": minH,
                "left": fn.options.left[minKey]
            });
            container.css("height", Math.max.apply({}, fn.options.height));
        },
        getarraykey: function(s, v) {
            for (k in s) {
                if (s[k] == v) {
                    return k;
                }
            }
        }
    }
    // Collection method.
    $.fn.waterfall = function(options) {
        console.log(this)
        var url = options.url
        fn.init(this)
    };

    // Static method.
    $.waterfall = function(options) {
        // Override default options with passed-in options.
        options = $.extend({}, $.waterfall.options, options);
        // Return something waterfall.
        return 'waterfall' + options.punctuation;
    };

    // Static method default options.
    $.waterfall.options = {
      renderTo: "#waterfall"
    };

    // fn.init("#waterfall", "li");
}(jQuery));