document.addEventListener('DOMContentLoaded', function() {
  webSocketSetup();
});

function webSocketSetup(){

  var protocol = location.protocol === 'https:' ? 'wss' : 'ws';

  var ws       = new WebSocket(protocol + '://' + window.location.host + window.location.pathname);
  ws.onopen    = function(){};
  ws.onclose   = function(){};
  ws.onmessage = function(message){console.log(message.data);};

  var sender = function(f){
    f.addEventListener('mousedown', function(){
      ws.send(f.getAttribute("data-direction") + " start");
      return false;
    });
    f.addEventListener('mouseup', function(){
      ws.send(f.getAttribute("data-direction") + " stop");
      return false;
    });
  };

  var buttons = document.getElementsByClassName('control-button');
  for(var i = 0; i < buttons.length; i++){
     sender(buttons.item(i));
  }
}