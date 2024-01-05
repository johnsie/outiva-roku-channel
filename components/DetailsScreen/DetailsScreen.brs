' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

 ' inits details screen
 ' sets all observers
 ' configures buttons for Details screen
Function Init()
  print "DetailsScreen.brs - [init]"
  m.top.observeField("visible", "onVisibleChange")
  m.top.observeField("focusedChild", "OnFocusedChildChange")

  m.buttons           =   m.top.findNode("Buttons")
  m.videoPlayer       =   m.top.findNode("VideoPlayer")
  m.poster            =   m.top.findNode("Poster")
  m.description       =   m.top.findNode("Description")
  m.background        =   m.top.findNode("Background")
  m.fadeIn            =   m.top.findNode("fadeinAnimation")
  m.fadeOut           =   m.top.findNode("fadeoutAnimation")

  ' create buttons
  result = []
  for each button in ["Play", "Second button"]
    result.push({title : button})
  end for
  m.buttons.content = ContentList2SimpleNode(result)
End Function

' set proper focus to buttons if Details opened and stops Video if Details closed
Sub onVisibleChange()
  print "DetailsScreen.brs - [onVisibleChange]"
  if m.top.visible
    m.fadeIn.control="start"
    m.buttons.jumpToItem = 0
    m.buttons.setFocus(true)
  else
    m.fadeOut.control="start"
    m.videoPlayer.visible = false
    m.videoPlayer.control = "stop"
    m.poster.uri=""
    m.background.uri=""
  end if
End Sub

' set proper focus to Buttons in case if return from Video PLayer
Sub OnFocusedChildChange()
  print "DetailsScreen.brs - [OnFocusedChildChange]"
  if m.top.isInFocusChain() and not m.buttons.hasFocus() and not m.videoPlayer.hasFocus() then
    m.buttons.setFocus(true)
  end if
End Sub

' set proper focus on buttons and stops video if return from Playback to details
Sub onVideoVisibleChange()
  print "DetailsScreen.brs - [onVideoVisibleChange]"
  if m.videoPlayer.visible = false and m.top.visible = true
    m.buttons.setFocus(true)
    m.videoPlayer.control = "stop"
  end if
End Sub

' event handler of Video player msg
Sub OnVideoPlayerStateChange()
  print "DetailsScreen.brs - [OnVideoPlayerStateChange]"
  if m.videoPlayer.state = "error"
    ' error handling
    m.videoPlayer.visible = false
  else if m.videoPlayer.state = "playing"
    ' playback handling
  else if m.videoPlayer.state = "finished"
    m.videoPlayer.visible = false
  end if
End Sub

' on Button press handler
Sub onItemSelected()
  print "DetailsScreen.brs - [onItemSelected]"
  ' first button is Play
  if m.top.itemSelected = 0
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
  end if
End Sub

' Content change handler
Sub OnContentChange()
  print "DetailsScreen.brs - [OnContentChange]"
  m.description.content           = m.top.content
  m.description.Description.width = "1120"
  m.videoPlayer.content           = m.top.content
  m.top.streamUrl                 = m.top.content.url
  m.poster.uri                    = m.top.content.hdBackgroundImageUrl
  m.background.uri                = m.top.content.hdBackgroundImageUrl
End Sub

'///////////////////////////////////////////'
' Helper function convert AA to Node
Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
  print "DetailsScreen.brs - [ContentList2SimpleNode]"
  result = createObject("roSGNode", nodeType)
  if result <> invalid
    for each itemAA in contentList
      item = createObject("roSGNode", nodeType)
      item.setFields(itemAA)
      result.appendChild(item)
    end for
  end if
  return result
End Function
