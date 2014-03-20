fadeSpeed = 200

specialPages = [
  /\/wiki\/Category:.*/
  /\/wiki\/Wikipedia:.*/
  /\/wiki\/Wikimedia:.*/
]

isSpecialPage = (href) ->
  for pattern in specialPages
    return true if href.match pattern

firstParagraph = ' #mw-content-text > p:first:not(:has(#coordinates))'

class Instant
  @elem: $('<div id="better-wikipedia-instant"><div id="better-wikipedia-instant-content"></div></div>').hide()
  @content: @elem.find '#better-wikipedia-instant-content'

  @init: ->
    $('#mw-content-text').append @elem
    $("#bodyContent a[href^='/wiki']").removeAttr('title')
    .hover (e) =>
      return if isSpecialPage e.currentTarget.href
      @load e.currentTarget.href, => @show e.currentTarget.offsetTop
    , => @hide()
    # hide stray boxes
    @elem.hover null, => @hide()

  @load: (link, loadedFn) ->
    @content.load link + firstParagraph, loadedFn

  @show: (top) ->
    @elem.fadeIn fadeSpeed
    @elem.css
      top: top

  @hide: ->
    @elem.fadeOut fadeSpeed

class SidePanel
  @elem: $('#mw-panel')

  @activeBorderWidth: 50

  @init: ->
    @elem.hide()
    @elem.hover null, => @hide()
    $(document).mousemove (e) => @show() if e.clientX < @activeBorderWidth

  @hide: ->
    @elem.fadeOut fadeSpeed

  @show: ->
    @elem.fadeIn fadeSpeed

$ ->
  Instant.init()
  SidePanel.init()