Sub Init()
    m.port=createobject("romessageport")
    m.top.observeField("transportResponse", m.port)
    m.ExtVideo = m.top.getScene().findNode("Video")

    m.top.functionName = "listenInput"
End Sub

function ListenInput()

    InputObject=createobject("roInput")
    InputObject.setmessageport(m.port)
    if m.global.version >= "910"
      InputObject.enableTransportEvents()
    end if

    while true
      msg=m.port.waitmessage(500)
      if type(msg)="roInputEvent" then
        print "INPUT EVENT!"
        if msg.isInput()
          inputData = msg.getInfo()
          'print inputData'
          for each item in inputData
            print item  +": " inputData[item]
          end for

          ' pass the deeplink to UI
          if inputData.DoesExist("mediaType") and inputData.DoesExist("contentID")
            deeplink = {
                id: inputData.contentID
                mediaType: inputData.mediaType
                type: "deeplink"
            }
            print "got input deeplink= "; deeplink
            m.top.inputData = deeplink
          else if m.global.version >= "910" and inputData.DoesExist("type") and inputData.type = "transport"
            transport = {
                id: inputData.id
                command: inputData.command
                duration: inputData.duration
                direction: inputData.direction
                type: inputData.type
            }
            print "got transport input= "; transport
            ret = m.ExtVideo.callFunc("handleTransport", inputData)
            print "transport event response= "; {id:inputData.id, status: ret}
            InputObject.EventResponse({id:inputData.id, status: ret})
          end if
        end if
      end if
    end while
end function