
function playSound() {
	document.getElementById("audiofile").addEventListener("ended", function(){
		this.load();
		this.play();
	});
	document.getElementById("audiofile").play();
}

function stopSound()
{
  document.getElementById("audiofile").pause();
  document.getElementById("audiofile").load();  
 
}
