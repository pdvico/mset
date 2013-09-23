document.getElementById("ping").addEventListener('ended',function(){
    this.currentTime=0;
},false);

document.getElementById("shine").addEventListener('ended',function(){
    this.currentTime=0;
    this.play();
},false);

function playPing() {
    document.getElementById("ping").play();
}

function playShine(){
    document.getElementById("shine").play();
}
