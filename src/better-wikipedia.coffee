fadeSpeed = 200
hoverDelay = 500

specialPages = [
  /\/wiki\/Category:.*/
  /\/wiki\/Wikipedia:.*/
  /\/wiki\/Wikimedia:.*/
]

isSpecialPage = (href) ->
  for pattern in specialPages
    return true if href.match pattern

firstParagraphSelector = ' #mw-content-text > p:first:not(:has(#coordinates))'

div = (id) ->
  element = document.createElement 'div'
  element.id = id
  element

class Instant
  @init: ->
    @instantBox = div 'better-wikipedia-instant'
    @content = div 'better-wikipedia-instant-content'
    @instantBox.appendChild @content
    $('#mw-content-text').append @instantBox
    links = $("#bodyContent a[href^='/wiki']")
    links.hover @onHoverIn, @onHoverOut
    # Remove the little yellow hover preview rendered by default.
    links.removeAttr 'title'
    # hide stray boxes
    @instantBox.hover null, @onHoverOut

  @onHoverIn: (event) ->
    link = event.currentTarget
    return if isSpecialPage link.href
    firstParagraph = link.href + firstParagraphSelector
    @content.load firstParagraph, => @showInstantBoxFor link

  @onHoverOut: (event) =>
    link = event.currentTarget
    @hideInstantBoxFor link

  @showInstantBoxFor: (link) =>
    link.setAttribute 'will-preview', 'set by Better Wikipedia extension.'
    display = =>
      # The user has already hovered away from the link, so don't do anything.
      return if not link.hasAttribute 'will-preview'
      console.log 'show', link
      link.removeAttribute 'will-preview'
      @instantBox.fadeIn fadeSpeed
      @instantBox.css
        top: link.offsetTop
    window.setTimeout display, hoverDelay

  @hideInstantBoxFor: (link) =>
    link.removeAttribute 'will-preview'
    @instantBox.fadeOut fadeSpeed

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
