@Connect = React.createClass

    handleSubmit: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return
      
      @setState followValue: "Stop blinddating"
      @setState showFollowing: true
      $.ajax
        url: "/users/#{@state.userId}/turnonbd"
        type: 'PUT'
        data: 
          user: @state.userId
          
          
      window.location = "http://localhost:3000/";
      


    handleSubmitUnFollow: (e) ->
      e.preventDefault()

      $('.btn').mouseup ->
        $(this).blur()
        return

      @setState followValue: "Start blinddating"
      @setState showFollowing: false
      $.ajax
        url: "/users/#{@state.userId}/turnoffbd"
        type: 'PUT'
        data: 
          user: @state.userId
          
      window.location = "http://localhost:3000/";


    getInitialState: ->

      $('.btn').mouseup ->
        $(this).blur()
        return

      followValue: @props.followValue 
      showFollowing: @props.showFollowing
      userId: @props.userId

    render: ->
      if @state.showFollowing
        React.DOM.button
          className: 'btn btn-danger btn-sm'
          style: {width:'100%'}
          onClick: @handleSubmitUnFollow
          React.DOM.i
            className: 'fa fa-stop'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue
      else
        React.DOM.button
          className: 'btn btn-success btn-sm'
          style: {width:'100%'}
          onClick: @handleSubmit
          React.DOM.i
            className: 'fa fa-play'
          React.DOM.span style:{'paddingLeft':'2px'}, @state.followValue

      